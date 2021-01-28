# Create Forwarding Rule

resource "google_compute_forwarding_rule" "default" {
  provider              = google-beta
  project               = var.project
  name                  = "${var.name}-forwarding-rule"
  region                = var.region
  network               = var.network
  subnetwork            = var.subnetwork
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.default.self_link
  ip_address            = var.ip_address
  ip_protocol           = var.protocol
  ports                 = var.ports
  labels                = var.custom_labels
}


# Create Backend Service

resource "google_compute_region_backend_service" "default" {
  project          = var.project
  name             = "${var.name}-internal-lb"
  region           = var.region
  protocol         = var.protocol
  timeout_sec      = var.timeout_sec
  session_affinity = var.session_affinity

  dynamic "backend" {
    for_each = var.backends
    content {
	  description = ""
      group       = backend.value
    }
  }
  health_checks   = var.health_checks
}
