# encoding: utf-8

"""SQLAlchemy Metadata and Session object"""
from typing import Any, Optional
from sqlalchemy import MetaData, event
import sqlalchemy.orm as orm
from sqlalchemy.engine import Engine

from ckan.types import AlchemySession


__all__ = ['Session']

# SQLAlchemy database engine. Updated by model.init_model()
engine: Optional[Engine] = None


Session: AlchemySession = orm.scoped_session(orm.sessionmaker(
    autoflush=False,
    autocommit=False,
    expire_on_commit=False,
))


create_local_session = orm.sessionmaker(
    autoflush=False,
    autocommit=False,
    expire_on_commit=False,
)


def _is_domain_object(v: Any):
    from ckan.model.domain_object import DomainObject
    return isinstance(v, DomainObject)


@event.listens_for(create_local_session, 'before_flush')
@event.listens_for(Session, 'before_flush')
def ckan_before_flush(session: Any, flush_context: Any, instances: Any):
    """ Create a new _object_cache in the Session object.

    _object_cache is used in DomainObjectModificationExtension to trigger
    notifications on changes. e.g: re-indexing a package in solr upon update.
    """
    if not hasattr(session, '_object_cache'):
        session._object_cache = {'new': set(),
                                 'deleted': set(),
                                 'changed': set()}

    changed = [
        obj for obj in session.dirty
        if _is_domain_object(obj)
        and session.is_modified(obj, include_collections=False)
    ]

    session._object_cache['new'].update(filter(_is_domain_object, session.new))
    session._object_cache['deleted'].update(
        filter(_is_domain_object, session.deleted)
    )
    session._object_cache['changed'].update(changed)

    # Collect physical files of resources that are deleted or changed
    _collect_files_to_delete(session)


@event.listens_for(create_local_session, 'after_commit')
@event.listens_for(Session, 'after_commit')
def ckan_after_commit(session: Any):
    """ Cleans our custom _object_cache attribute after committing.
    """
    if hasattr(session, '_object_cache'):
        del session._object_cache

    if hasattr(session, '_files_to_delete'):
        for up, res_id, filepath in session._files_to_delete:
            try:
                if hasattr(up, 'delete'):
                    up.delete(res_id)
            except Exception as e:
                import logging
                logging.getLogger('ckan.model').error(
                    "Failed to delete physical file for resource %s: %s", res_id, e
                )
        del session._files_to_delete


@event.listens_for(create_local_session, 'before_commit')
@event.listens_for(Session, 'before_commit')
def ckan_before_commit(session: Any):
    """ Calls all extensions implementing IDomainObjectModification interface.
    """
    from ckan.model.modification import DomainObjectModificationExtension
    dome = DomainObjectModificationExtension()
    dome.before_commit(session)


@event.listens_for(create_local_session, 'after_rollback')
@event.listens_for(Session, 'after_rollback')
def ckan_after_rollback(session: Any):
    """ Cleans our custom _object_cache attribute after rollback.
    """
    if hasattr(session, '_object_cache'):
        del session._object_cache
    if hasattr(session, '_files_to_delete'):
        del session._files_to_delete


def _collect_files_to_delete(session: Any):
    import ckan.model as ckan_model
    import ckan.lib.uploader as uploader
    from sqlalchemy.orm.attributes import get_history

    if not hasattr(session, '_files_to_delete'):
        session._files_to_delete = set()

    # Process deleted resources
    for obj in session.deleted:
        if isinstance(obj, ckan_model.Resource):
            if getattr(obj, 'url_type', None) == 'upload':
                try:
                    up = uploader.get_resource_uploader({})
                    filepath = up.get_path(obj.id)
                    session._files_to_delete.add((up, obj.id, filepath))
                except Exception:
                    pass

    # Process deleted packages (purge)
    for obj in session.deleted:
        if isinstance(obj, ckan_model.Package):
            for resource in obj.resources:
                if getattr(resource, 'url_type', None) == 'upload':
                    try:
                        up = uploader.get_resource_uploader({})
                        filepath = up.get_path(resource.id)
                        session._files_to_delete.add((up, resource.id, filepath))
                    except Exception:
                        pass

    # Process dirty (modified) packages and resources
    for obj in session.dirty:
        # Package state changed to 'deleted'
        if isinstance(obj, ckan_model.Package):
            state_history = get_history(obj, 'state')
            if state_history.added and state_history.added[0] == 'deleted':
                for resource in obj.resources:
                    if resource.state != 'deleted':
                        resource.state = 'deleted'
                        if getattr(resource, 'url_type', None) == 'upload':
                            try:
                                up = uploader.get_resource_uploader({})
                                filepath = up.get_path(resource.id)
                                session._files_to_delete.add((up, resource.id, filepath))
                            except Exception:
                                pass

        # Resource state changed to 'deleted' or url_type changed from 'upload'
        elif isinstance(obj, ckan_model.Resource):
            state_history = get_history(obj, 'state')
            state_changed_to_deleted = False
            if state_history.added and state_history.added[0] == 'deleted':
                state_changed_to_deleted = True

            url_type_history = get_history(obj, 'url_type')
            url_type_changed_from_upload = False
            if url_type_history.deleted and 'upload' in url_type_history.deleted:
                if obj.url_type != 'upload':
                    url_type_changed_from_upload = True

            is_upload = getattr(obj, 'url_type', None) == 'upload' or (
                url_type_history.deleted and 'upload' in url_type_history.deleted
            )
            if (state_changed_to_deleted or url_type_changed_from_upload) and is_upload:
                try:
                    up = uploader.get_resource_uploader({})
                    filepath = up.get_path(obj.id)
                    session._files_to_delete.add((up, obj.id, filepath))
                except Exception:
                    pass


mapper = orm.mapper  # type: ignore

metadata = MetaData()
registry = orm.registry(metadata=metadata)
