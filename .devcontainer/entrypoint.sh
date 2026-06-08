#!/bin/bash
set -e

cd /workspace

# Install CKAN sebagai package (editable, cepat karena deps sudah ada di image)
pip install -e ".[dev]" --quiet

# Buat ckan.ini jika belum ada
if [ ! -f /workspace/ckan.ini ]; then
    ckan generate config /workspace/ckan.ini

    # Set konfigurasi otomatis
    sed -i 's|sqlalchemy.url = .*|sqlalchemy.url = postgresql://ckan_default:pass@localhost/ckan_default|' /workspace/ckan.ini
    sed -i 's|#ckan.site_url = .*|ckan.site_url = http://localhost:5000|' /workspace/ckan.ini
    sed -i 's|#solr_url = .*|solr_url = http://localhost:8983/solr/ckan|' /workspace/ckan.ini
    sed -i 's|#ckan.redis.url = .*|ckan.redis.url = redis://localhost:6379/0|' /workspace/ckan.ini

    echo "✅ ckan.ini berhasil dibuat"
fi

# Init database jika belum
ckan -c /workspace/ckan.ini db init

# Jalankan CKAN
exec ckan -c /workspace/ckan.ini run --host 0.0.0.0 --port 5000
