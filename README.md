# EKS exercise

The repository contains the terraform code to instantiate a EKS cluster and some helm chart for testing purpoises (like stressing CPU, web servers, fluentbit and cloudwatch agent)

## Repository content: directories

- cluster_eks: main directory for terraform code
- modules: terraform modules
- helm_chart: some helm charts for testing purposes

### helm charts

Some helm charts letting to do some experiments:

- base_eks: it install fluentbit, cloudwatch agent, autoscaler, k8s dashboard
- deploy-ubuntu: let to deploy ubuntu executing the provided (in configmap) script
- simple-nginx: let to deploy a really simple nginx deployment


## Terraform module: eks_on_ecs

The module eks_on_ecs let to install EKS using EC2 instances as data plane.

Supported features:
- autoscaler (it create the needed policies) - this need the helm chart base_eks
- load balancers (it create the needed policies)
- cloudwatch logs groups used by the fluentbit/cloudwatch agent (in particular it let to set the retention periods and to create the needed policies: TODO: policies too open) - this need the helm chart base_eks
- instantiate the iodc provider (aws_iam_openid_connect_provider resource): this let to use AWS IAM to connect to AWS services
- policies to let the use AWS IAMs by pods

## How to

### apply with auto approve

```bash
cd cluster_eks

# terraform
terraform init
terraform apply -auto-approve

# get k8s confs
aws eks update-kubeconfig --name `terraform output -raw cluster_name`

# install metric server on the cluster
echo "------- installing metrics-server"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

```

### helm charts

```bash
cd cluster_eks

helm upgrade --install --force  --namespace deploy-ubuntu --create-namespace  testing ../helm_charts/deploy-ubuntu/ --set aws_account_number=$(aws sts get-caller-identity --query "Account" --output text)
# TO REMOVE: helm uninstall -n deploy-ubuntu testing

helm upgrade --install   base-eks ../helm_charts/base_eks \
 --set aws_account_number=$(aws sts get-caller-identity --query "Account" --output text) \
 --set roleArnForAutoscaler=$(terraform output -raw arn_autoscaler_role)
# TO REMOVE: helm uninstall base-eks

helm upgrade --install  --namespace simple-nginx --create-namespace simple-nginx ../helm_charts/simple-nginx/
# TO REMOVE: helm uninstall -n simple-nginx simple-nginx

```


