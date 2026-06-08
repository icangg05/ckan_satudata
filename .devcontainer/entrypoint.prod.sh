#!/bin/bash
set -e

# Buat ckan.ini jika belum ada
if [ ! -f /workspace/ckan.ini ]; then
    ckan generate config /workspace/ckan.ini
    sed -i "s|sqlalchemy.url = .*|sqlalchemy.url = ${CKAN_SQLALCHEMY_URL}|" /workspace/ckan.ini
    sed -i "s|#ckan.site_url = .*|ckan.site_url = ${CKAN_SITE_URL}|" /workspace/ckan.ini
    sed -i "s|#solr_url = .*|solr_url = ${CKAN_SOLR_URL}|" /workspace/ckan.ini
    sed -i "s|#ckan.redis.url = .*|ckan.redis.url = ${CKAN_REDIS_URL}|" /workspace/ckan.ini
    sed -i "s|ckan.secret_key = .*|ckan.secret_key = ${CKAN_SECRET_KEY}|" /workspace/ckan.ini

    # Matikan debug mode
    sed -i "s|debug = true|debug = false|" /workspace/ckan.ini
fi

ckan -c /workspace/ckan.ini db init

# Gunicorn untuk production (bukan werkzeug)
exec gunicorn \
    --workers 4 \
    --worker-class gevent \
    --bind 0.0.0.0:5000 \
    --timeout 120 \
    --access-logfile - \
    --error-logfile - \
    "wsgi:application"
