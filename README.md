# Civo DeployKF

## Introduction

This project provides a [Terraform](https://www.terraform.io/) configuration to set up a [DeployKF](https://www.deploykf.org/) on a [Civo](https://www.civo.com/) Kubernetes cluster.

## Prerequisites

* [Civo](https://www.civo.com/) account with API key
* [Terraform](https://www.terraform.io/) installed on your system
* [Kubernetes](https://kubernetes.io/) client (e.g., [Lens](https://k8slens.dev/), [kubectl](https://kubernetes.io/docs/reference/kubectl/), [k9s](https://k9scli.io/) etc) for interacting with the cluster
* [Bash](https://www.gnu.org/software/bash/) version 4.4 or higher installed on your system (required for the sync script)
* [ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/) (optional, for managing DeployKF deployments)

You can upgrade your Bash version on macOS using Homebrew:
```bash
brew install bash
```

This installation will typically place the new Bash binary in `/opt/homebrew/bin/bash`. You will need to specify this path in the `terraform.tfvars` file.

## Infrastructure Setup

To set up and deploy the Kubernetes cluster, follow these steps:

1. Create `vars.tfvars` from the template:
```hcl
civo_token = "your_civo_api_key"
region     = "your_civo_region"  # Change to your preferred region. Default is "LON1".
bash_path  = "your_bash_path"  # Change this to your preferred bash path. Default is "/opt/homebrew/bin/bash" (Installed with brew).
```
Replace `"your_civo_api_key"` with your actual Civo API key.

2. Initialize Terraform:
```bash
terraform init
```

3. Plan the Terraform configuration:
```bash
terraform plan
```

4. Apply the Terraform configuration:
```bash
terraform apply
```

5. Retrieve the kubeconfig from the Civo dashboard and load it into your kubecontext.

## ArgoCD (Optional)

[DeployKF](https://www.deploykf.org/) is deployed through [ArgoCD](https://argo-cd.readthedocs.io/en/stable/), which is already installed on the cluster provisioned through Terraform. You can access the ArgoCD Web UI to see the DeployKF application being deployed. This is optional but recommended to see if anything goes wrong during the deployment.

You can first expose the ArgoCD service by patching the service to use a LoadBalancer:

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

You can then access ArgoCD using the LoadBalancer IP address. The default username is `admin`, and the password can be retrieved using:

```bash
echo $(kubectl -n argocd get secret/argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
```

## Accessing Kubeflow

The DeployKF dashboard is exposed through the LoadBalancer IP address of the `deploykf-gateway` service. This service is automatically created by DeployKF and will route traffic to the Kubeflow dashboard.

**IMPORTANT NOTE:** You cannot access the Kubeflow dashboard using the LoadBalancer IP address directly. Instead, you need to set up a DNS record that points to the LoadBalancer IP address.

Add this to your ```/etc/hosts``` file for local testing:

```bash
<LoadBalancer_IP> deploykf.example.com
<LoadBalancer_IP> argo-server.deploykf.example.com
<LoadBalancer_IP> minio-api.deploykf.example.com
<LoadBalancer_IP> minio-console.deploykf.example.com
```

## Troubleshooting

* Common issues and their solutions will be documented here. For more information on troubleshooting [DeployKF](https://www.deploykf.org/docs/latest/troubleshooting/), please refer to the official documentation.

## Configuration Files

* `vars.tfvars`: Contains the [Civo](https://www.civo.com/) API key and other variables for [Terraform](https://www.terraform.io/).
* `deploykf-values.yaml`: Configuration for [DeployKF](https://www.deploykf.org/), a Kubernetes deployment tool.

## Contributing and Support

* Contributions are welcome. Please submit pull requests or issues on our GitHub repository.
* For support, please contact raise a GitHub issue in this repository.
