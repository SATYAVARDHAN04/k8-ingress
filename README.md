# KUBERNETES

*NOTE* : WE CAN INSTALL KUBERNETES IN MANY WAYS 

## STEP 1: CONFIGURE AWS CLI
## STEP 2: INSTALL EKSCTL FOR K8S CLUSTER CREATION

```bash
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl
```
## STEP 3: INSTALL KUBECTL FOR K8S CLUSTER INTERACTION

```bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.3/2025-08-03/bin/linux/amd64/kubectl
```
```bash
chmod +x ./kubectl
```
```bash
sudo mv kubectl /usr/local/bin/kubectl
```

## STEP 4: CHECK WHETHER INSTALLED PROPERLY
```bash
eksctl version
kubectl version
```
## STEP 5: NOW WE WILL CREATE A MANAGED NODE GROUP or IN SHORT A CLUSTER WITH A MASTER AND WORKER NODES

*NOTE: A MANAGED NODE GROUP IS THE SET OF AWS WORKER NODES(INSTANCES) THAT AWS WILL CREATE AND MANAGE ON ITS OWN*
```bash
eksctl create cluster --config-file=eks.yaml
```
```bash
eksctl delete cluster --config-file=eks.yaml
```

## SHOW WORKER NODES IN A WORKSTATION

```bash
kubectl get nodes
```

## RESOURCES DISCUSSED IN THIS REPO

### NAMESPACE

Creation of namespace 
```bash
kubectl apply -f namespace.yaml
```

Cheking of namespace created 
```bash
kubectl get namespace
```

Deletion of namespace 
```bash
kubectl delete -f namespace.yaml
```

### PODS

Creation of PODS
```bash
kubectl apply -f pod.yaml
```

Cheking of pods created 
```bash
kubectl get pods
```

Deletion of pods 
```bash
kubectl delete -f pod.yaml
```

To Know the logs of a pod
```bash
kubectl describe pod <podname>
```

To login into any pod 
```bash
kubectl exec -it <pod_name> -- bash
```

To login into a container of a pod having multiple containers
```bash
kubectl exec -it <pod_name> -c <container_name> -- bash
```

To check which pod is running on which worker node
```bash
kubectl get pods -o wide
```
### LABELS

### ANNOTATIONS

### RESOURCE LIMITING

To know how much memory is used by each pod
```bash
kubectl top pods
```

### ENV VARIABLES

Enter into the container and check for env variables

```bash
docker exec -it <container_name> -- bash
```
```bash
env
```

To check whether the **config map** is created and running

```bash
kubectl get configmap
```

*NOTE: when there is any chnage in the configuration we make the necessary changes in the config map file and restart the pod*


### SERVICE

To check service have been create or not
```bash
kubectl get svc
```

To delete a service we can use
```bash
kubectl delete svc <service_name>
```

To check endpoints, ClusterIp
```bash
kubectl describe svc <service_name> 
```
```bash
kubectl describe svc <service_name> -o wide
```
**SOME IMPORTANT POINTS REGARDING SERVICES**
1. When you are creating a Cluster IP service you cannot access the application via an externally it is only used for communication between pods internally
2. When you are creating a Node Port service you can access the point externally via internet only if the port number is configured in the security group of the worker nodes
3. When you are creating a Load Balancer service the configuration would be automatically set as the requests from the loadbalancer will be accepted by the security group of the worker nodes ans the website can be accessible via DNS name given by the loadbalancer.

### REPLICA SET

To get the pods
```bash
kubectl get pods
```

### DEPLOYMENT

To get the replica set
```bash
kubectl get rs
```
To get the pods inside the replica set
```bash
kubectl get pods
```

---
## VOLUMES

Since nodes and pods are ephermal it is not recommended to store data in them so we use the concept of volumes like AWS EBS, AWS EFC to store data. We us PVC,PV and SC wrapper classes for creation,delection and manipulation of storage.

There are 2 types of storage provisioning
1. Static provisioning
2. Dynamic Provisioning

EBS Static Provisioning


