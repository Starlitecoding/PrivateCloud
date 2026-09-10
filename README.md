# PrivateCloud — Infrastructure & DevOps Lab

A containerized private cloud laboratory built with Docker Compose to demonstrate practical skills in **Linux networking, infrastructure, storage, backup, reverse proxying, and observability**.

The project simulates a small private-cloud environment with an isolated LAN, a Linux gateway performing NAT, application services, S3-compatible object storage, encrypted backups, and a Prometheus/Grafana monitoring stack.

---


## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd PrivateCloud
```

### 2. Create environment configuration

```bash
cp .env.example .env
```

Edit `.env` and provide your own credentials.

> `.env` is excluded from Git and should never be committed.

### 3. Start the infrastructure

```bash
docker compose up -d --build
```

### 4. Check container status

```bash
docker compose ps
```

Infrastructure services should report `healthy` where healthchecks are configured.

---

## Architecture

```text
                         ┌──────────────────┐
                         │  Mock Internet   │
                         │   nginx:alpine   │
                         └────────┬─────────┘
                                  │
                              WAN network
                                  │
                         ┌────────▼─────────┐
                         │     Gateway      │
                         │   Linux / NAT    │
                         │  IP forwarding   │
                         └────────┬─────────┘
                                  │
                       LAN 10.10.10.0/24
                                  │
          ┌───────────────────────┼────────────────────────┐
          │                       │                        │
    ┌─────▼─────┐           ┌─────▼─────┐           ┌─────▼─────┐
    │   Nginx   │           │   App 1   │           │   App 2   │
    │   :9999   │           │  :5678    │           │  :5678    │
    └───────────┘           └───────────┘           └───────────┘

                         Monitoring
                              │
                       ┌──────▼──────┐
                       │  cAdvisor   │
                       └──────┬──────┘
                              │
                       ┌──────▼──────┐
                       │ Prometheus  │
                       └──────┬──────┘
                              │
                       ┌──────▼──────┐
                       │   Grafana   │
                       └─────────────┘

                         Backup path
                              │
                       ┌──────▼──────┐
                       │    Kopia    │
                       │  encryption │
                       │ deduplication│
                       └──────┬──────┘
                              │ S3
                       ┌──────▼──────┐
                       │    MinIO    │
                       │ S3 storage  │
                       └─────────────┘
```

---

## What This Project Demonstrates

### Networking

* Docker bridge networks
* Segmented WAN/LAN architecture
* Static container IP addressing
* Linux IP forwarding
* Network Address Translation (NAT)
* `iptables`
* Service-to-service communication over an isolated network

LAN subnet:

```text
10.10.10.0/24
```

| Component  | IP            |
| ---------- | ------------- |
| Gateway    | `10.10.10.3`  |
| Nginx      | `10.10.10.19` |
| MinIO      | `10.10.10.12` |
| cAdvisor   | `10.10.10.30` |
| Prometheus | `10.10.10.31` |
| Grafana    | `10.10.10.32` |
| App 1      | `10.10.10.21` |
| App 2      | `10.10.10.22` |

---

## Reverse Proxy

Nginx provides a single entry point for the application services:

```text
localhost:9999/app1/
localhost:9999/app2/
```

Requests are routed internally to the corresponding application container.

Example:

```bash
curl http://localhost:9999/app1/
curl http://localhost:9999/app2/
```

---

## Object Storage & Backups

MinIO provides an S3-compatible object storage layer.

Kopia uses MinIO as its S3 repository rather than copying files directly between buckets.

```text
Application / backup data
          │
          ▼
        Kopia
          │
   encryption + deduplication
          │
          ▼
     MinIO / S3
```

The Kopia repository stores encrypted, deduplicated and chunked backup data inside the S3-compatible storage backend.

### Backup retention

```text
Hourly:   48
Daily:     7
Weekly:    4
Monthly:   24
Annual:    3
Latest:    10
```

A restore operation was performed successfully to verify that the backup pipeline works end-to-end.

---

## Monitoring & Observability

The project includes:

```text
Docker containers
      │
      ▼
   cAdvisor
      │
      ▼
 Prometheus
      │
      ▼
  Grafana
```

Prometheus collects container metrics from cAdvisor.

The Grafana dashboard currently tracks:

* CPU usage
* Memory usage
* Network RX
* Network TX

Docker healthchecks are also configured for key infrastructure services:

* Nginx
* MinIO
* cAdvisor
* Prometheus
* Grafana

---

## Technology Stack

| Area            | Technologies                  |
| --------------- | ----------------------------- |
| Containers      | Docker, Docker Compose        |
| Networking      | Linux, iptables, NAT, TCP/IP  |
| Reverse Proxy   | Nginx                         |
| Object Storage  | MinIO / S3                    |
| Backup          | Kopia                         |
| Monitoring      | Prometheus, Grafana, cAdvisor |
| Configuration   | YAML                          |
| Version Control | Git / GitHub                  |

---

## Project Structure

```text
PrivateCloud/
│
├── docker-compose.yml
├── .env.example
├── .gitignore
├── README.md
│
├── gateway/
│   ├── Dockerfile
│   ├── iptables.sh
│   └── mock-index.html
│
├── compute/
│   └── nginx.conf
│
└── monitoring/
    ├── prometheus.yml
    └── grafana/
        ├── dashboards/
        └── provisioning/
            └── dashboards/
```

Secrets are provided through environment variables and are intentionally excluded from version control.

---


### 5. Test the applications

```bash
curl http://localhost:9999/app1/
curl http://localhost:9999/app2/
```

### 6. Access the interfaces

| Service       | Address                  |
| ------------- | ------------------------ |
| Nginx         | `http://localhost:9999`  |
| MinIO Console | `http://localhost:9001`  |
| Prometheus    | `http://localhost:9090`  |
| Grafana       | `http://localhost:3000`  |
| Kopia         | `http://localhost:51515` |

---

## Design Decisions

### Why Docker Compose?

The project was designed as a portable infrastructure laboratory that can run on both Windows and macOS without requiring a full VM-based environment.

### Why separate WAN and LAN networks?

The network separation makes the lab closer to a real infrastructure environment and allows the gateway to act as a controlled boundary between networks.

### Why MinIO + Kopia?

MinIO provides an S3-compatible storage layer while Kopia provides encrypted, deduplicated and incremental backup functionality.

This separates the **storage backend** from the **backup system**, similar to how infrastructure components are commonly layered in production environments.

### Why Prometheus + Grafana + cAdvisor?

The stack demonstrates the basic observability pipeline:

```text
Metrics exporter → Metrics storage → Visualization
```

---

## Verification

Example verification commands:

```bash
docker compose ps
```

```bash
curl http://localhost:9999/app1/
```

```bash
curl http://localhost:9999/app2/
```

Prometheus targets can be checked through:

```text
http://localhost:9090/targets
```

Container resource metrics are visualized through Grafana.

The backup workflow was additionally verified through a test restore.

---

## Key Learning Outcomes

This project was built to gain practical experience with:

* Docker Compose infrastructure design
* Linux networking
* IP forwarding and NAT
* `iptables`
* reverse proxy configuration
* S3-compatible object storage
* encrypted and deduplicated backups
* backup retention policies
* container healthchecks
* Prometheus metrics collection
* Grafana dashboards
* infrastructure configuration management
* Git-based infrastructure workflows

---

## Future Learning Path

This project intentionally focuses on foundational infrastructure rather than attempting to reproduce an entire production cloud platform.

The next stage of the learning path is:

```text
PrivateCloud
     │
     ▼
   AWS
     │
     ▼
 Terraform
     │
     ▼
 CI/CD
     │
     ▼
 Kubernetes
```

The goal is to transfer the infrastructure concepts demonstrated here into public-cloud and cloud-native environments.
