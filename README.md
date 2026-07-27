# Infra Automation VPS

Terraform script untuk automasi provisioning VPS. Script ini akan:
- Menghubungkan VPS via SSH
- Update & upgrade package system
- Install Nginx, curl, git, unzip
- Enable & start Nginx
- Membuat halaman web default

## Prasyarat

- [Terraform](https://www.terraform.io/downloads) v1.15+
- Akses SSH ke VPS (key pair)
- VPS dengan OS **Debian/Ubuntu** (user default: `ubuntu`)

## Struktur File

```
├── main.tf                  # Konfigurasi utama Terraform (provisioning script)
├── variables.tf             # Definisi variabel (vps_ip, vps_user, ssh_key)
├── terraform.tfvars         # Nilai variabel (IP VPS) - EXCLUDED dari git
├── .gitignore               # File yang di-exclude dari git
├── .terraform.lock.hcl      # Lock file versi provider
└── README.md                # Dokumentasi proyek
```

## Setup - Step by Step

### 1. Clone Repository

```bash
git clone <url-repo>
cd infra-automation-vps
```

### 2. Persiapan SSH Key

Pastikan SSH key sudah ada di mesin lokal:

```bash
# Cek apakah key sudah ada
ls ~/.ssh/id_ed25519

# Jika belum ada, buat baru
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Copy public key ke VPS:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub ubuntu@<IP_VPS>
```

### 3. Buat File `terraform.tfvars`

Buat file `terraform.tfvars` dan isi dengan IP VPS Anda:

```bash
echo 'vps_ip = "43.157.204.137"' > terraform.tfvars
```

> **PENTING:** File `terraform.tfvars` sudah di-exclude oleh `.gitignore`. Jangan commit file ini ke repository karena berisi IP VPS Anda.

### 4. Inisialisasi Terraform

```bash
terraform init
```

Output yang diharapkan:
```
Terraform has been successfully initialized!
```

### 5. Plan - Cek Rencana Perubahan

```bash
terraform plan
```

Periksa output untuk memastikan tidak ada error.

### 6. Apply - Jalankan Provisioning

```bash
terraform apply
```

Ketik `yes` saat diminta konfirmasi.

Proses provisioning akan:
1. Menghubungkan ke VPS via SSH
2. Menjalankan `apt-get update` dan `upgrade`
3. Install nginx, curl, git, unzip
4. Enable & start service nginx
5. Membuat halaman web di `/var/www/html/index.html`
6. Verifikasi nginx berjalan

### 7. Verifikasi

Buka browser dan akses:

```
http://<IP_VPS>
```

Harus muncul halaman: **"Provisioning Terraform Berhasil! Server siap digunakan."**

## Cleanup

Untuk menghapus semua resources yang sudah dibuat:

```bash
terraform destroy
```

Ketik `yes` saat diminta konfirmasi.

## Keamanan

- **`.gitignore`** melindungi file sensitif agar tidak ter-upload ke GitHub:
  - `*.tfstate` - data state infrastructure
  - `.terraform/` - provider cache
  - `*.tfvars` - file credential/secret
- **`terraform.tfvars`** berisi IP VPS Anda. File ini tidak di-commit ke repository.

## Troubleshooting

| Masalah | Solusi |
|---|---|
| SSH timeout | Pastikan IP VPS benar dan port 22 terbuka |
| Permission denied | Jalankan `ssh-copy-id` untuk copy public key ke VPS |
| Nginx tidak start | Cek log: `ssh ubuntu@<IP_VPS> "sudo systemctl status nginx"` |
| `terraform init` error | Pastikan Terraform sudah terinstall: `terraform version` |
