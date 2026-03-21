# INGRESS CONTROLLER

## INSTALL EKSCTL FOR K8S CLUSTER CREATION

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

## INSTALL KUBECTL FOR K8S CLUSTER INTERACTION

```bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.3/2025-08-03/bin/linux/amd64/kubectl
```
```bash
chmod +x ./kubectl
```
```bash
sudo mv kubectl /usr/local/bin/kubectl
```

## NOW WE WILL CREATE A MANAGED NODE GROUP or IN SHORT A CLUSTER WITH A MASTER AND WORKER NODES

*NOTE: A MANAGED NODE GROUP IS THE SET OF AWS WORKER NODES(INSTANCES) THAT AWS WILL CREATE AND MANAGE ON ITS OWN*
```bash
eksctl create cluster --config-file=eks.yaml
```
```bash
eksctl delete cluster --config-file=eks.yaml
```


### OIDC PROVIDER

```bash
REGION_CODE=us-east-1
CLUSTER=roboshop-newproject
ID=517695827891
```


```bash
eksctl utils associate-iam-oidc-provider \
    --region $REGION_CODE \
    --cluster $CLUSTER \
    --approve
```

### DOWNLOAD IAM POLICY

```bash
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v3.1.0/docs/install/iam_policy.json
```

### CREATE IAM POLICY

```bash
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```

### CREATE IAM ROLE AND K8 SERVICEACCOUNT AND THIS ALSO MAPS BETWEEN IAM ROLE AND K8S SERVICE

```bash
eksctl create iamserviceaccount \
--cluster=$CLUSTER \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::$ID:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--region $REGION_CODE \
--approve
```

### INSTALL LOAD BALANCER CONTROLLER DRIVERS

```bash
helm repo add eks https://aws.github.io/eks-charts
```

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=$CLUSTER --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
```

```bash
kubectl get sa
```

```bash
kubectl get sa -n kube-system
```

```bash
kubectl get pods -n kube-system
```

```bash
kubectl logs <pod-name> -n kube-system
```

```bash
kubectl describe ingress <ingress_name>
```