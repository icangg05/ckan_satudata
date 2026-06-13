"""
Patch datapusher/jobs.py so that when messytables.any_tableset() raises
ImportError (e.g. 'pdftables is not installed'), it is caught and re-raised
as a proper util.JobError instead of crashing the APScheduler job runner.

This handles the case where a resource was previously a PDF and DataPusher
still tries to parse it as such due to a stale content-type.
"""
import re
import sys

JOBS_PATH = (
    '/usr/lib/python3.8/site-packages/'
    'datapusher-0.0.19-py3.8.egg/datapusher/jobs.py'
)

with open(JOBS_PATH, 'r') as f:
    content = f.read()

# The original line (line ~433 in datapusher 0.0.19):
# "        table_set = messytables.any_tableset(tmp, mimetype=ct, extension=ct)"
# We wrap it in a try/except that converts ImportError -> JobError.

OLD = (
    '        table_set = messytables.any_tableset(tmp, mimetype=ct, extension=ct)\n'
)
NEW = (
    '        try:\n'
    '            table_set = messytables.any_tableset(tmp, mimetype=ct, extension=ct)\n'
    '        except ImportError as _import_err:\n'
    '            raise util.JobError(\n'
    '                \'File format not supported (missing library): \'\n'
    '                \'{0}. If you uploaded a PDF, please re-upload as CSV/XLSX.\'\n'
    '                .format(_import_err))\n'
)

if OLD in content:
    patched = content.replace(OLD, NEW, 1)
    with open(JOBS_PATH, 'w') as f:
        f.write(patched)
    print('patch_datapusher_jobs.py: patched jobs.py successfully.')
else:
    # Already patched or different version - just warn, don't fail the build.
    print(
        'patch_datapusher_jobs.py: WARNING - expected pattern not found in '
        'jobs.py. The file may already be patched or this is a different '
        'version. Skipping patch.',
        file=sys.stderr,
    )
