# 🛠️ Lesson 7: Troubleshooting & Maintenance

Kubernetes is a complex system. Even with perfect manifests, issues like resource exhaustion or version bugs can crash your applications. This lesson covers how to debug and fix the most common issues encountered in this project.

---

## 1. The "Disk Full" Trap (`ImagePullBackOff`)
If your pod status is `ImagePullBackOff` and you see errors like `no space left on device` in the events:

### Symptoms
- `kubectl get pods` shows `ImagePullBackOff`.
- `kubectl describe pod <name>` shows `Failed to pull image... no space left on device`.

### The Problem
The `prdx-kube101` VM has a fixed disk size. If Docker downloads too many large images or logs grow too big, the cluster cannot download new container data.

### The Fix
1. **Clean Docker**: Free up space by removing unused images/containers.
   ```bash
   docker system prune -a -f
   ```
2. **Expand the VM Disk**: Increase the disk size in your hypervisor (e.g., from 10GB to 15GB).
3. **Grow the Partition**:
   ```bash
   # Expand partition 2
   sudo growpart /dev/nvme0n1 2
   # Resize LVM Physical Volume
   sudo pvresize /dev/nvme0n1p2
   # Resize Logical Volume and Grow Filesystem
   sudo lvextend -l +100%FREE /dev/mapper/rlm-root -r
   ```

---

## 2. The Headlamp "Version Bug" (`v0.40.1`)
Sometimes, software updates break existing configurations. We experienced this with Headlamp.

### The Problem
Headlamp version `0.40.1` introduced a packaging bug where the startup script passed a `-session-ttl` flag that the server no longer recognized. This caused the pod to crash immediately (`CrashLoopBackOff`).

### The Lesson: Version Pinning
Never use `@latest` or unpinned versions in production. 
- **Good**: `version: 0.40.0`
- **Risky**: `version: latest`

By pinning to a known stable version in our `DEPLOYMENT_OPERATIONS.md`, we ensure the cluster remains stable even if a broken update is released.

---

## 3. The Debugging Toolkit
When an application fails, follow this "Outside-In" hierarchy:

1. **Check Networking (`Ingress`)**: 
   `kubectl get ingress -A` (Is the host correct?)
2. **Check the Logic (`Service`)**: 
   `kubectl get svc -A` (Does it have an IP? Are the ports correct?)
3. **Check the Vital Signs (`Pod`)**: 
   `kubectl get pods -A` (Is it Running? Status?)
4. **Read the Error Logs**:
   `kubectl logs <pod-name>` (What is the app saying?)
5. **Describe the Object**:
   `kubectl describe pod <pod-name>` (Check the "Events" at the bottom for pull errors or scheduling issues).

---

## 🎉 Conclusion: Graduation!
Congratulations! You have navigated the entire Kubernetes Capstone curriculum. You have built a cluster from scratch, deployed load-balanced apps, integrated enterprise monitoring, managed secure access with RBAC, and learned how to troubleshoot real-world production failures.

**You are now ready to manage and scale this infrastructure!**
