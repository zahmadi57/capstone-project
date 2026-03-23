# 🔐 Lesson 6: Persistent Access & Kubernetes RBAC

## The Token Problem
By default, `kubectl create token` generates a **temporary** token (usually valid for 1 hour). When using a dashboard like **Headlamp**, this results in frequent logouts, which can be frustrating in a lab environment.

To solve this, we use **Role-Based Access Control (RBAC)** to create a dedicated Service Account with a **long-lived** (permanent) token.

---

## 1. Concepts: Service Accounts & RBAC
*   **Service Account (SA)**: An identity for a process (like Headlamp) to act as a user within the cluster.
*   **ClusterRole**: A set of permissions (e.g., `cluster-admin` allows doing anything).
*   **ClusterRoleBinding**: The "glue" that connects a Service Account to a ClusterRole.
*   **Secret**: A Kubernetes object used to store sensitive data, like a long-lived authentication token.

---

## 2. Implementation Steps

### Step 1: Create the Identity
Create a Service Account specifically for administrative access via Headlamp.
```bash
kubectl create serviceaccount headlamp-admin -n kube-system
```

### Step 2: Grant Permissions
Assign the `cluster-admin` role to the new Service Account so you can view and manage all namespaces.
```bash
kubectl create clusterrolebinding headlamp-admin-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:headlamp-admin
```

### Step 3: Create a Permanent Token
Since Kubernetes v1.24+, tokens are no longer generated automatically for Service Accounts. We must manually create a `Secret` of type `kubernetes.io/service-account-token`.

Create a file named `headlamp-admin-token.yaml`:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: headlamp-admin-token
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: "headlamp-admin"
type: kubernetes.io/service-account-token
```

Apply the manifest:
```bash
kubectl apply -f headlamp-admin-token.yaml
```

### Step 4: Retrieve and Save
Fetch the token string. Unlike standard tokens, this one **will not expire** unless the Secret is deleted.
```bash
kubectl get secret headlamp-admin-token -n kube-system -o jsonpath='{.data.token}' | base64 --decode
```

---
**Next Step:** Proceed to [Lesson 7: Troubleshooting & Maintenance](./07_troubleshooting_and_maintenance.md) to learn how to recover from common cluster issues like disk exhaustion.

## 3. Best Practices
*   **In Production**: Never use `cluster-admin` for personal dashboards. Instead, create a Role with specific "read-only" permissions.
*   **Storage**: Store this token in a safe location (like a password manager), not in plaintext within your repository.
*   **Persistence**: Because this token is stored in the cluster's database (`etcd`), it survives Pod restarts, Node reboots, and even cluster downtime.
