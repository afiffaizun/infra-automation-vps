terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

resource "null_resource" "konfigurasi_vps" {

  # Jalankan ulang provisioning jika file ini berubah
  triggers = {
    always_run = timestamp()
  }

  connection {
    type        = "ssh"
    host        = var.vps_ip
    user        = var.vps_user
    private_key = file(pathexpand(var.ssh_private_key_path))
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '=== Memulai Provisioning ==='",

      # Update package
      "export DEBIAN_FRONTEND=noninteractive",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",

      # Install software
      "sudo apt-get install -y nginx curl git unzip",

      # Enable & start nginx
      "sudo systemctl enable nginx",
      "sudo systemctl restart nginx",

      # Buat halaman web
      "echo '<h1>Provisioning Terraform Berhasil!</h1><p>Server siap digunakan.</p>' | sudo tee /var/www/html/index.html > /dev/null",

      # Verifikasi
      "nginx -v",
      "systemctl is-active nginx",

      "echo '=== Provisioning Selesai ==='"
    ]
  }
}

output "vps_url" {
  value = "http://${var.vps_ip}"
}