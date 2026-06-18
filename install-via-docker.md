# Panduan Install & Migrasi Project CKAN via Docker

> Catatan: project ini dipindah ke server dengan cara di-**zip** lalu di-extract langsung di
> server. Jadi seluruh data file (folder `ckan_storage/storage`) **sudah ikut terbawa** di
> dalam zip. Yang TIDAK ikut otomatis adalah isi database PostgreSQL — karena itu kedua
> database harus di-**export dulu di lokal** (lihat bagian 0), file hasil export-nya
> dimasukkan ke dalam folder project sebelum di-zip, lalu di-restore di server (step 4 & 5).

---

## 0. Export dua database (DILAKUKAN DI LOKAL, SKIP JIKA SUDAH ADA)

Sistem CKAN ini punya **dua** database yang sama-sama wajib dibawa:

| Database            | Isi                                                              |
| ------------------- | --------------------------------------------------------------- |
| `ckan_default`      | metadata: user, dataset, organisasi, grup, dll.                 |
| `datastore_default` | isi tabel datastore (data hasil push DataPusher / data tabel).  |

Jalankan perintah berikut **di mesin lokal** (komputer tempat project saat ini jalan),
dari dalam folder project, supaya file hasil export tersimpan di folder project dan ikut
terbawa saat di-zip ke server:

```bash
# Buat folder penampung backup
mkdir -p backup_database

# Export metadata
docker exec devcontainer-db-1 pg_dump -U ckan_default ckan_default      > backup_database/ckan_default.dump

# Export isi datastore
docker exec devcontainer-db-1 pg_dump -U ckan_default datastore_default > backup_database/datastore_default.dump
```

Setelah kedua file `backup_database/ckan_default.dump` dan
`backup_database/datastore_default.dump` ada di folder project, zip seluruh folder project
(sudah termasuk `ckan_storage/storage` dan folder `backup_database` tadi), lalu kirim &
extract di server.

---

## Step install project di server (urutan benar)

```bash
# 1. Up semua container (db, solr, redis, datapusher, ckan)
docker compose -f .devcontainer/docker-compose.yml up -d

# 2. Pastikan ckan_default & datastore_default benar-benar KOSONG sebelum restore.
#    (drop & buat ulang — aman karena sumber data ada di file dump. WITH (FORCE)
#     otomatis memutus koneksi container ckan yang masih nyangkut.)
docker exec -i devcontainer-db-1 psql -U ckan_default -d postgres -c "DROP DATABASE IF EXISTS ckan_default WITH (FORCE);"
docker exec -i devcontainer-db-1 psql -U ckan_default -d postgres -c "CREATE DATABASE ckan_default OWNER ckan_default ENCODING 'UTF8';"
docker exec -i devcontainer-db-1 psql -U ckan_default -d postgres -c "DROP DATABASE IF EXISTS datastore_default WITH (FORCE);"
docker exec -i devcontainer-db-1 psql -U ckan_default -d postgres -c "CREATE DATABASE datastore_default OWNER ckan_default ENCODING 'UTF8';"

# 3. Restore metadata ke DB kosong (dump membawa skema + data sekaligus, TANPA db init)
docker exec -i devcontainer-db-1 psql -U ckan_default -d ckan_default < backup_database/ckan_default.dump

# 4. Restore data datastore ke DB kosong
docker exec -i devcontainer-db-1 psql -U ckan_default -d datastore_default < backup_database/datastore_default.dump

# 5. ⭐ Setup datastore — bikin view _table_metadata & beri SELECT ke read-user
#    untuk tabel yang baru di-restore. WAJIB dijalankan SETELAH restore datastore.
#    IMPORTANT!: jika error, kemungkinan masih proses running program. tunggu beberapa detik sampai halaman terload
docker exec devcontainer-ckan-1 ckan -c /workspace/ckan.ini datastore set-permissions \
  | docker exec -i devcontainer-db-1 psql -U ckan_default -d postgres -v ON_ERROR_STOP=1

# 6. Rebuild index Solr (setelah restore metadata)
docker exec devcontainer-ckan-1 ckan -c /workspace/ckan.ini search-index rebuild
```

> Catatan: kalau ini server yang benar-benar baru pertama kali up, `ckan_default` &
> `datastore_default` sudah otomatis dibuat dalam keadaan kosong oleh container db, jadi
> step 2 (drop & create) sebenarnya hanya jaga-jaga agar prosedur ini idempotent / aman
> diulang. Verifikasi cepat setelah restore: jumlah user & dataset harus sesuai data lama,
> bukan cuma 1.
>
> ```bash
> docker exec -i devcontainer-db-1 psql -U ckan_default -d ckan_default -c 'SELECT count(*) FROM "user";'
> docker exec -i devcontainer-db-1 psql -U ckan_default -d ckan_default -c 'SELECT count(*) FROM package;'
> ```

> File upload (resource, logo organisasi/grup, dll.) disimpan di filesystem pada
> `ckan.storage_path = /workspace/ckan_storage` (folder `ckan_storage/storage`). Karena
> project di-pindah lewat zip yang sudah memuat folder tersebut, **tidak perlu langkah copy
> file tambahan** — pastikan saja folder `ckan_storage/storage` ikut ter-extract di server.

> ⚠️ **Production:** pastikan di `ckan.ini` server, baris `debug = false` (baris 38) — **jangan
> `true`**. Mode debug membuka fitur yang bisa dipakai pengunjung untuk menjalankan kode
> berbahaya di server.

> ⚠️ **JANGAN LUPA ubah `ckan.site_url`** di `ckan.ini` server, **baris 79**:
>
> ```ini
> # dari default:
> ckan.site_url = http://localhost:5000
> # jadi domain / IP server sebenarnya, contoh:
> ckan.site_url = https://satudata.kendarikota.go.id
> ```
>
> URL ini dipakai CKAN untuk membentuk link absolut (email, sitemap, share, API, dll). Kalau
> masih `localhost:5000`, banyak link & redirect akan rusak saat diakses dari luar server.
> Setelah diubah, restart container ckan: `docker compose -f .devcontainer/docker-compose.yml restart ckan`.

---

## Catatan soal Tailwind CSS (PENTING)

**Server TIDAK perlu install Node.js.** Image Docker di-build dengan `NODE_VERSION="none"`
(lihat `.devcontainer/Dockerfile`), dan **proses `docker compose up` / `docker build` TIDAK
menjalankan build Tailwind sama sekali**. Jadi di server cukup `docker compose up -d`, tanpa
npm/node.

Alasannya: hasil build Tailwind adalah **file statis tunggal**:

```
ckan/public/base/css/tailwind.css
```

File inilah yang disajikan ke browser (via `{% asset 'css/tailwind' %}` di
`ckan/templates/base.html`). Karena project dipindah lewat **zip**, file `tailwind.css` yang
sudah ter-build **ikut terbawa** ke server — jadi tampilan langsung jalan tanpa build ulang.

**Build Tailwind dilakukan DI LOKAL** (bukan di server), setiap kali ada perubahan
class/template, sebelum nge-zip & kirim ke server:

```bash
# di mesin lokal (butuh Node + sudah `npm install`)
npm run build-tailwind
# = tailwindcss -i ./ckan/public/base/css/tailwind-src.css \
#                -o ./ckan/public/base/css/tailwind.css --minify
```

- **Source / input:** `ckan/public/base/css/tailwind-src.css`
- **Output (yang dibawa ke server):** `ckan/public/base/css/tailwind.css`

> Ringkasnya: edit class → `npm run build-tailwind` di lokal → pastikan `tailwind.css` ter-update
> → baru zip & kirim ke server. Di server cukup `docker compose up`, **tidak ada build Node/Tailwind**.
