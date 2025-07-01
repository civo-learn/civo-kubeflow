# Civo DeployKF

## Introduction

This project provides a [Terraform](https://www.terraform.io/) configuration to set up a [DeployKF](https://www.deploykf.org/) on a [Civo](https://www.civo.com/) Kubernetes cluster.

## Prerequisites

* [Civo](https://www.civo.com/) account with API key
* [Terraform](https://www.terraform.io/) installed on your system
* [Kubernetes](https://kubernetes.io/) client (e.g., [Lens](https://k8slens.dev/), [kubectl](https://kubernetes.io/docs/reference/kubectl/), [k9s](https://k9scli.io/) etc) for interacting with the cluster

## Infrastructure Setup

To set up and deploy the Kubernetes cluster, follow these steps:

1. Create `vars.tfvars` from the template:
```hcl
civo_token = "your_civo_api_key"
region     = "your_civo_region"  # Change to your preferred region. Default is "LON1".
```
Replace `"your_civo_api_key"` with your actual Civo API key.

2. Initialize Terraform:
```bash
terraform init
```

3. Plan the Terraform configuration:
```bash
terraform plan --var-file="vars.tfvars"
```

4. Apply the Terraform configuration:
```bash
terraform apply --var-file="vars.tfvars"
```

5. Retrieve the kubeconfig from the Civo dashboard and load it into kubecontext.

## Deploying DeployKF

DeployKF is deployed through [ArgoCD](https://argo-cd.readthedocs.io/en/stable/), which is already installed on the cluster provisioned through Terraform. You can access the ArgoCD Web UI to see the DeployKF application being deployed. This is optional but recommended to see if anything goes wrong during the deployment.

You can first expose the ArgoCD service by patching the service to use a LoadBalancer:

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

You can then access ArgoCD using the LoadBalancer IP address. The default username is `admin`, and the password can be retrieved using:

```bash
echo $(kubectl -n argocd get secret/argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
```

1. Apply the Kyverno configuration:
```bash
kubectl apply -f kyverno.yaml
```

2. Apply the DeployKF configuration:
```bash
kubectl apply -f deploykf-values.yaml
```

After this step you should see a deploykf App of Apps application in the ArgoCD UI.

3. Run the ArgoCD apps sync script:
```bash
bash sync_argocd_apps.sh
```

## Troubleshooting

* Common issues and their solutions will be documented here. For more information on troubleshooting [DeployKF](https://www.deploykf.org/docs/latest/troubleshooting/), please refer to the official documentation.

## Configuration Files

* `vars.tfvars`: Contains the [Civo](https://www.civo.com/) API key and other variables for [Terraform](https://www.terraform.io/).
* `kyverno.yaml`: Configuration for [Kyverno](https://kyverno.io/), a Kubernetes policy engine.
* `deploykf-values.yaml`: Configuration for [DeployKF](https://www.deploykf.org/), a Kubernetes deployment tool.

## Contributing and Support

* Contributions are welcome. Please submit pull requests or issues on our GitHub repository.
* For support, please contact raise a GitHub issue in this repository.
