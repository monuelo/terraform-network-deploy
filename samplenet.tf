# Create the samplenetwork network
resource "google_compute_network" "samplenetwork" {
  name                    = "samplenetwork"
  auto_create_subnetworks = true
}

# Create a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on samplenetwork
resource "google_compute_firewall" "samplenetwork_allow_http_ssh_rdp_icmp" {
  name    = "samplenetwork-allow-http-ssh-rdp-icmp"
  network = "${google_compute_network.samplenetwork.self_link}"
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  allow {
    protocol = "icmp"
  }
}

# Create the samplenet-us-vm instance
module "samplenet-us-vm" {
  source              = "./instance"
  instance_name       = "samplenet-us-vm"
  instance_zone       = "us-central1-a"
  instance_subnetwork = "${google_compute_network.samplenetwork.self_link}"
}

# Create the samplenet-eu-vm" instance
module "samplenet-eu-vm" {
  source              = "./instance"
  instance_name       = "samplenet-eu-vm"
  instance_zone       = "europe-west1-d"
  instance_subnetwork = "${google_compute_network.samplenetwork.self_link}"
}

