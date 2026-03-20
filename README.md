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

### CREATE IAM ROLE AND K8 SERVICEACCOUNT MAPPING BETWEEN IAM ROLE AND K8S SERVICE

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

