# Set permission datastore di database PostgreSQL container

docker compose -f .devcontainer/docker-compose.yml exec ckan ckan -c ckan.ini datastore set-permissions
docker compose -f .devcontainer/docker-compose.yml exec -T db psql -U
ckan_default -d datastore_default

======================================================================

# 1. Buat user ckan_admin

docker compose -f .devcontainer/docker-compose.yml exec ckan bash -c "ckan -c /workspace/ckan.ini user add ckan_admin email=admin@example.com password=test1234" || true

# 2. Jadikan ckan_admin sebagai sysadmin

docker compose -f .devcontainer/docker-compose.yml exec ckan bash -c "ckan -c /workspace/ckan.ini sysadmin add ckan_admin" || true

# 3. Buat token untuk DataPusher

docker compose -f .devcontainer/docker-compose.yml exec ckan bash -c "ckan -c /workspace/ckan.ini user token add ckan_admin datapusher"

======================================================================

# 1. Masuk ke container datapusher dan pasang xlrd versi 1.2.0 (yang mendukung .xlsx)

docker compose -f .devcontainer/docker-compose.yml exec -u 0 datapusher pip install xlrd==1.2.0

# 2. Restart container datapusher agar perubahan aktif

docker compose -f .devcontainer/docker-compose.yml restart datapusher

======================================================================

1. Masuk ke container
   docker compose exec ckan bash

======================================================================

2. Setup & jalankan CKAN secara manual di dalam container
   => cd /workspace

# Install semua library dependency

=> pip install -r requirements.txt

# Install CKAN sebagai command/package

=> pip install -e ".[dev]"

# Buat file konfigurasi CKAN

=> ckan generate config /workspace/ckan.ini

# Edit konfigurasi — sesuaikan bagian ini

nano /workspace/ckan.ini

======================================================================

3. Ubah baris-baris berikut di ckan.ini:

sqlalchemy.url = postgresql://ckan_default:pass@localhost/ckan_default

ckan.site_url = http://localhost:5000

solr_url = http://localhost:8983/solr/ckan

ckan.redis.url = redis://localhost:6379/0

======================================================================

4. Inisialisasi database
   ckan -c /workspace/ckan.ini db init

======================================================================

5. Jalankan CKAN
   ckan -c /workspace/ckan.ini run --host 0.0.0.0 --port 5000

======================================================================

6. Cek Port Forwarding
   Pastikan di devcontainer.json ada forward port:
   json"forwardPorts": [5000, 5432, 8983]
