#!/bin/bash
set -e

cd /workspace

# Install CKAN
pip install -e ".[dev]" --no-deps --quiet

if [ ! -f /workspace/ckan.ini ]; then
    ckan generate config /workspace/ckan.ini

    sed -i 's|sqlalchemy.url = .*|sqlalchemy.url = postgresql://ckan_default:pass@localhost/ckan_default|' /workspace/ckan.ini
    sed -i 's|#ckan.site_url = .*|ckan.site_url = http://localhost:5000|' /workspace/ckan.ini
    sed -i 's|#solr_url = .*|solr_url = http://localhost:8983/solr/ckan|' /workspace/ckan.ini
    sed -i 's|#ckan.redis.url = .*|ckan.redis.url = redis://localhost:6379/0|' /workspace/ckan.ini
    sed -i 's|debug = false|debug = true|' /workspace/ckan.ini

    echo "✅ ckan.ini berhasil dibuat"
fi

# Selalu pastikan storage_path benar (dijalankan setiap container start)
sed -i 's|ckan.storage_path = .*|ckan.storage_path = /workspace/ckan_storage|' /workspace/ckan.ini
mkdir -p /workspace/ckan_storage/storage

ckan -c /workspace/ckan.ini db init

# Setup permission datastore + bikin view _table_metadata (WAJIB agar upload Excel/CSV
# bisa masuk datastore). Idempotent, aman dijalankan setiap container start.
ckan -c /workspace/ckan.ini datastore set-permissions \
    | PGPASSWORD=pass psql -U ckan_default -h localhost -d postgres
echo "✅ datastore permissions di-setup"

exec ckan -c /workspace/ckan.ini run --host 0.0.0.0 --port 5000
