docker exec devcontainer-db-1 pg_dump -U ckan_default ckan_default > /home/icang/Desktop/website/private/ckan/backup_ckan_$(date +%Y%m%d).sql

1. Export database di local

# Masuk ke container db local
docker compose exec db bash

# Export database
pg_dump -U ckan_default ckan_default > /tmp/ckan_backup.sql

# Keluar dari container
exit

# Copy file backup ke host/local machine
docker compose cp db:/tmp/ckan_backup.sql ./ckan_backup.sql


======================================================================


2. Copy file backup ke server

# Dari local machine, kirim ke server via scp
scp ./ckan_backup.sql user@yourserver.com:/home/user/ckan_backup.sql


======================================================================


3. Import database di server

# Di server, masuk ke folder project
cd /path/to/project

# Pastikan container db sudah running
docker compose -f docker-compose.prod.yml up -d db

# Copy file backup ke container db
docker compose -f docker-compose.prod.yml cp ./ckan_backup.sql db:/tmp/ckan_backup.sql

# Masuk ke container db
docker compose -f docker-compose.prod.yml exec db bash

# Import database
psql -U ckan_default ckan_default < /tmp/ckan_backup.sql

# Keluar
exit


======================================================================


4. Jalankan semua service

docker compose -f docker-compose.prod.yml up -d
