# 📦 Kubernetes Lab Manifests

This directory contains the operational code required to deploy the cluster routing components and the Lab Application.

For a detailed theoretical breakdown of *how* these files work, refer to `kubernetes/learning_materials/03_manifests_deep_dive.md`.

> **Prerequisite:** Before running these commands, ensure DNS records for the Kubernetes app subdomains exist on `prdx-dns101` by running the DNS setup playbook. All apps are accessed via hostname, routed through the NGINX Ingress Controller on Port 80.

---

## 🚀 Deployment Instructions

Run these commands sequentially from your `prdx-kube101` terminal to deploy the application stack.

### 1. Configure the Host Firewall
Open only the core HTTP/HTTPS ports. All apps are served through the Ingress Controller — no per-app NodePorts are required.
```bash
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --reload
```

### 2. Deploy the NGINX Ingress Controller
Applies the provider-specific kind Ingress routing logic.
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```
*Wait for the `ingress-nginx-controller` pod to report `Running (1/1)` before moving on:*
```bash
kubectl get pods -n ingress-nginx
```

### 3. Deploy Headlamp (Kubernetes UI)
Installs the Headlamp dashboard via Helm. It is deployed as a `ClusterIP` service and exposed through the NGINX Ingress Controller.
```bash
helm repo add headlamp https://kubernetes-sigs.github.io/headlamp/
helm repo update

helm upgrade --install headlamp headlamp/headlamp \
  --version 0.40.0 \
  --namespace kube-system \
  --set service.type=ClusterIP
```
> **Note:** Chart version `0.40.0` is pinned deliberately. Chart `0.40.1` has a known packaging bug where it generates a `-session-ttl` flag that was removed from the binary, causing a `CrashLoopBackOff`.

Then apply the Ingress routing rule:
```bash
kubectl apply -f headlamp-ingress.yaml
```
**Access:** Navigate your browser to `http://headlamp.project.local`
*(Generate a token via `kubectl create token default`)*

### 4. Deploy the Lab Application
Applies the Deployment, internal Service, and host-based Ingress rule.
```bash
kubectl apply -f lab-app-deployment.yaml
kubectl apply -f lab-app-service.yaml
kubectl apply -f lab-app-ingress.yaml
```

**Access:** Navigate your browser to `http://app.project.local`
Run this to watch load-balancing between the two Pods:
```bash
curl http://app.project.local
```
