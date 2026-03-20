# INGRESS CONTROLLER

### OIDC PROVIDER

```bash
REGION_CODE=us-east-1
CLUSTER=roboshop-dev
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
--attach-policy-arn=arn:aws:iam::5714785:policy/AWSLoadBalancerControllerIAMPolicy \
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