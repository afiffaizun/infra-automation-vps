variable "vps_ip" {
    description = "IP address of the VPS to be provisioned"
    type       = string
}

variable "vps_user" {
    description = "Username for SSH connection to the VPS"
    type       = string
    default   = "ubuntu"
}

variable "ssh_private_key_path" {
    description = "Path to the SSH private key for connecting to the VPS"
    type       = string
    default   = "~/.ssh/id_ed25519"
}