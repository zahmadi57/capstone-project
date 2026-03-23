# ☸️ Kubernetes Capstone Implementation

Welcome to the Kubernetes infrastructure repository. 

This project provisions a local Kubernetes cluster utilizing **Ansible**, **Docker**, and **Kind**. It deploys a load-balanced web application, standard routing infrastructure (Ingress-NGINX), and a fully featured monitoring stack (Prometheus, Grafana, Headlamp).

---

## 🚀 Quick Start Deployment Guide

This document acts as the fast-track operational guide to get the cluster running.

### 1. Provision the Infrastructure
Run the Ansible playbook from your `prdx-ansible101` control node to install all dependencies and boot the underlying `kind` cluster.
```bash
ansible-playbook setup_kind.yml -i ../inventory
```

### 2. Deploy the Applications
Once the cluster is online, navigate to the **`manifests/`** directory to deploy the routing logic, the UI, and the target web apps.
👉 **[View Application Deployment Commands](./manifests/DEPLOYMENT_OPERATIONS.md)**

### 3. Deploy the Monitoring Stack (Bonus)
Navigate to the **`manifests/monitoring/`** directory to deploy the Prometheus and Grafana metrics aggregation stack.
👉 **[View Monitoring Stack Commands](./manifests/monitoring/MONITORING_SETUP.md)**

---

## 📚 Educational Deep-Dives

If you want to understand *how* Kubernetes works, why certain networking decisions were made, and how to read the complex configuration files without looking at raw operational commands, please follow the dedicated textbook syllabus located in the `learning_materials/` folder:

* 📖 **[Lesson 1: Infrastructure Provisioning Deep Dive](./learning_materials/01_infrastructure_provisioning.md)**
  * *Learn how Ansible interacts with the OS, how `kind` builds the cluster inside Docker, and why Port Mapping is critical.*
* 📖 **[Lesson 2: Kubernetes Architectural Flow](./learning_materials/02_kubernetes_architecture.md)**
  * *A conceptual deep dive with infographics explaining how Ingress Controllers act as "traffic cops".*
* 📖 **[Lesson 3: Manifests Deep Dive (Line-by-Line)](./learning_materials/03_manifests_deep_dive.md)**
  * *A line-by-line breakdown of every single parameter in the application deployments.*
* 📖 **[Lesson 4: The Monitoring Stack Architecture](./learning_materials/04_monitoring_stack.md)**
  * *Learn how to expose enterprise monitoring tools (Grafana/Prometheus) through production-grade host-based Ingress routing.*
* 📖 **[Lesson 5: Zero-Config Access with nip.io](./learning_materials/05_wildcard_dns_nip_io.md)**
  * *Learn how to bypass manual DNS/hosts file configuration using wildcard DNS mapping.*
* 📖 **[Lesson 6: Persistent Access & Kubernetes RBAC](./learning_materials/06_headlamp_tokens_and_rbac.md)**
  * *Learn how to create long-lived admin tokens and understand the fundamentals of Role-Based Access Control.*
* 📖 **[Lesson 7: Troubleshooting & Maintenance](./learning_materials/07_troubleshooting_and_maintenance.md)**
  * *A collection of real-world lessons covering disk expansion, version pinning, and cluster debugging.*
