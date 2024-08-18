# Backend services and infra

## Installation guide of the infra

The infra is written in Terraform
There's a `modules` directory for the EKS module and the addons modules for EKS

1. Install terraform version 1.6.X
2. Go to the `terraform/env/<env>` directory
3. First of all create the base network infra, `cd network`  and run `terraform init` and `apply`
4. Once the network part is created cd into the `eks` dir and run apply again
5. The EKS cluster is now created as well
NOTE: The EKS cluster is configured with 2 static nodes, which means it won't autoscale it.

## Installation guide of the of the services/infra on the EKS

1. Go to the `helm` directory
2. Go to the `external-secrets` dir and run `helm install -n kube-system -f values.yaml external-secrets-store .` -  this will install the cluster secret store which will be used to access the secrets in the secrets manager.
3. Go to `k8s-manifest` and run `kubectl apply -f gp3-storageclass-1b.yaml` this will install the storage class which will be used by mongo
4. Go to the `mongodb` dir and run `helm dependency update` and `helm upgrade --install -n mongodb --create-namespace -f values.yaml mongodb .` - this will install the `mongodb` helm chart
5. Install the service manifests - Go to `helm/service1` and `kubectl apply -f external-secret.yaml deployment.yaml svc.yaml`


You can view the deployed service at: `http://k8s-services-service1-2191cf5334-1268943612.eu-west-1.elb.amazonaws.com`

