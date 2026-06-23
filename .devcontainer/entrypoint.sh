#!/bin/bash
set -e

cd /app

# Install CKAN
pip install -e ".[dev]" --no-deps --quiet

if [ ! -f /app/ckan.ini ]; then
    ckan generate config /app/ckan.ini

    sed -i 's|sqlalchemy.url = .*|sqlalchemy.url = postgresql://ckan:supersecurepassword123@db/ckan|' /app/ckan.ini
    sed -i 's|#ckan.site_url = .*|ckan.site_url = http://localhost:5000|' /app/ckan.ini
    sed -i 's|#solr_url = .*|solr_url = http://solr:8983/solr/ckan|' /app/ckan.ini
    sed -i 's|#ckan.redis.url = .*|ckan.redis.url = redis://redis:6379/0|' /app/ckan.ini
    sed -i 's|debug = false|debug = true|' /app/ckan.ini

    echo "✅ ckan.ini berhasil dibuat"
fi

# Pastikan direktori storage ada. storage_path sendiri sudah dipaksa lewat env
# CKAN_STORAGE_PATH=/app/storage, jadi tidak perlu sed -i ke ckan.ini (file itu
# di-mount sebagai single file sehingga sed -i akan gagal "Device or resource busy").
mkdir -p /app/storage

ckan -c /app/ckan.ini db init

# Setup permission datastore + bikin view _table_metadata (WAJIB agar upload Excel/CSV
# bisa masuk datastore DAN tabel tampil di halaman resource lewat user read-only
# datastore_ro). Idempotent, aman dijalankan setiap container start.
# Catatan: psql connect ke service "db" (bukan localhost) sebagai superuser ckan_default.
ckan -c /app/ckan.ini datastore set-permissions \
    | PGPASSWORD=pass psql -U ckan_default -h db -d postgres
echo "✅ datastore permissions di-setup"

exec ckan -c /app/ckan.ini run --host 0.0.0.0 --port 5000
