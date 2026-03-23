# 📊 Kubernetes Monitoring Stack

This directory contains the custom Helm values and Ingress manifests required to deploy the `kube-prometheus-stack` into the local `kind` cluster.

For a detailed theoretical breakdown of the monitoring architecture, refer to `kubernetes/learning_materials/04_monitoring_stack.md`.

---

## 🚀 Deployment Instructions

Run these commands sequentially from your `prdx-kube101` terminal to deploy the complete metrics and visualization stack.

### 1. Configure the Host Firewall
If not already open from the main manifests setup, ensure Ports 80 and 443 are open (monitoring traffic is also routed via NGINX Ingress on Port 80).
```bash
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --reload
```

### 2. Install kube-prometheus-stack via Helm
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f monitoring/grafana-values.yaml
```
*Note: This stack includes dozens of pods. It may take a few minutes for them all to initialize. Check status with `kubectl get pods -n monitoring`.*

### 3. Apply Ingress Routing Rules
Expose Grafana and Prometheus through the NGINX Ingress Controller so they are accessible via hostname:
```bash
kubectl apply -f monitoring/grafana-ingress.yaml
kubectl apply -f monitoring/prometheus-ingress.yaml
```

### 4. Access Grafana (Visual Dashboards)
Navigate your browser to **`http://grafana.project.local`**
**Login:** `admin` / `admin`

### 5. Access Prometheus (Raw Metrics & Queries)
Navigate your browser to **`http://prometheus.project.local`**
