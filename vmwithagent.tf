################################
# GOOGLE PROVIDER
################################
provider "google" {
  project = "applied-polymer-479818-t7"
  region  = "us-central1"
  zone    = "us-central1-a"
}

################################
# ENABLE COMPUTE ENGINE API
################################
resource "google_project_service" "compute" {
  project             = "applied-polymer-479818-t7"
  service             = "compute.googleapis.com"
  disable_on_destroy  = false
}

################################
# FIREWALL (DEFAULT VPC)
################################
resource "google_compute_firewall" "allow_ssh_bindplane_test1" {
  name    = "allow-ssh-bindplane-test1"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "3001"]
  }

  source_ranges = ["0.0.0.0/0"]

  depends_on = [google_project_service.compute]
}

################################
# VM WITH BINDPLANE AGENT
################################
resource "google_compute_instance" "bindplane_vm_test1" {
  name         = "bindplane-agent-vm-test1"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 30
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral Public IP
    }
  }

  ################################
  # STARTUP SCRIPT – BINDPLANE AGENT
  ################################
  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e

    apt update -y
    apt install -y curl ca-certificates

    # Install BindPlane Agent
    sudo sh -c "$(curl -fsSlL 'https://bdot.bindplane.com/v1.89.0/install_unix.sh')" install_unix.sh \
      -e 'ws://bindplane-control-2:3001/v1/opamp' \
      -s '01KC8RJKWZKMARYG6F7J7MA6Q4' \
      -v '1.89.0' \
      -k 'install_id=42de39ab-a824-43a0-917d-886c668eecce'
  EOF

  depends_on = [
    google_project_service.compute,
    google_compute_firewall.allow_ssh_bindplane-test
  ]
}

################################
# OUTPUTS
################################
output "vm_name" {
  value = google_compute_instance.bindplane_vm.name
}

output "vm_public_ip" {
  value = google_compute_instance.bindplane_vm.network_interface[0].access_config[0].nat_ip
}

output "vm_internal_ip" {
  value = google_compute_instance.bindplane_vm.network_interface[0].network_ip
}
