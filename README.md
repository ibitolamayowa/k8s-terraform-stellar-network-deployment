# Stellar Network Deployment with Kubernetes and Terraform

This Terraform code deploys a Stellar network on a Kubernetes cluster. The deployment includes two main components: Stellar Core and Stellar Horizon. Stellar Core is responsible for validating transactions and maintaining the ledger, while Stellar Horizon provides a REST API for accessing the Stellar network.

## Prerequisites

Before running this code, you will need:

- A Kubernetes cluster with kubectl configured
- Terraform v0.14.11 or later installed on your machine
- The Stellar Core and Horizon Docker images

## Usage

1. Clone this repository:

```
git clone https://github.com/ibitolamayowa/k8s-terraform-stellar-network-deployment.git
```

2. Navigate to the `stellar-network` directory:

```
cd stellar-network
```

3. Edit the `variables.tf` file to set your desired variables.

4. Initialize the Terraform modules:

```
terraform init
```
5. Plan the Terraform code:

```
terraform plan
```

5. Apply the Terraform code:
```
terraform apply
```

6. Once the deployment is complete, you can access the Stellar Horizon API at `http://<horizon-load-balancer-ip>:8000`.

## Resources

This deployment includes the following resources:

- A Kubernetes namespace for the Stellar network
- A Kubernetes service account, role, and role binding for each component (Stellar Core and Stellar Horizon)
- A Kubernetes deployment for Stellar Core
- A Kubernetes deployment for Stellar Horizon
- A Kubernetes config map for Stellar Horizon configuration

## Notes

- This deployment assumes that you have a separate database for Stellar Core and that the database URL is stored in a Kubernetes secret.
- The default configuration assumes that you are using the testnet. If you want to use the public network, you will need to modify the Stellar Core and Horizon configuration files accordingly.
- This deployment does not include any security measures, such as SSL/TLS certificates or firewall rules. It is recommended that you add these measures to your production deployment.
Note that this is just an example README and should be modified to fit the specific needs of your deployment.
