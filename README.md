# PrivateCloud — Infrastructure & DevOps Lab

## Architecture

Docker Compose based private cloud lab demonstrating:

- isolated WAN/LAN networking
- Linux gateway with IP forwarding and NAT
- Nginx reverse proxy
- application services
- MinIO S3-compatible object storage
- Kopia encrypted incremental backups
- Prometheus + Grafana + cAdvisor monitoring

## Architecture

Internet simulation
|
mock-internet
|
gateway
/ \
 WAN LAN
|
+------+------+
| | |
nginx app1 app2
|
monitoring
|
Prometheus
|
Grafana
|
cAdvisor

Backup:

Kopia → MinIO (S3)
|
kopia-backups

## Networking

LAN: 10.10.10.0/24

gateway: 10.10.10.3
nginx: 10.10.10.19
MinIO: 10.10.10.12
cAdvisor: 10.10.10.30
Prometheus: 10.10.10.31
Grafana: 10.10.10.32

## Monitoring

Prometheus collects container metrics from cAdvisor.

Grafana dashboard provides:

- CPU usage
- RAM usage
- Network RX
- Network TX

## Backup

Kopia stores encrypted, deduplicated and chunked backup data
inside an S3-compatible MinIO repository.

Retention policy:

- hourly: 48
- daily: 7
- weekly: 4
- monthly: 24
- annual: 3

A restore operation was tested successfully.

## Run

```bash
docker compose up -d --build
```
