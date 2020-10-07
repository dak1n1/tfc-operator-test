# tfc-operator-test
A simple module to test [Terraform Cloud Operator](https://github.com/hashicorp/terraform-k8s) provisioning.

## Description

The following steps exist to assist with local development of the Terraform Cloud Operator. These steps describe how to compile and run the operator in a local Kubernetes cluster using Minikube.

Once installed, the operator will make API calls to Terraform Cloud, which runs the Terraform module in this repository. The test resource included in this module is created in AWS as a result.

The Workspace custom resource contains all the information Terraform Cloud Operator needs in order to execute this test in AWS.

### Prerequisites

* [Minikube](https://minikube.sigs.k8s.io/docs/)
* [Helm](https://helm.sh/)
* [Terraform Cloud](https://app.terraform.io) account (free is fine) with an Organization created.
* git clone [terraform-helm](https://github.com/hashicorp/terraform-helm)
* git clone [terraform-k8s](https://github.com/hashicorp/terraform-k8s)

### Usage

Ensure AWS environment variables are present and that the AWS API is accessible.

```
aws sts get-caller-identity
env |grep AWS
```

Ensure the following variables are defined. The session variables can be set to any value if using a static IAM user.

```
AWS_DEFAULT_REGION
AWS_SECRET_ACCESS_KEY
AWS_ACCESS_KEY_ID
AWS_SESSION_EXPIRATION
AWS_SESSION_TOKEN
```

Create a Kubernetes cluster using Minikube and push the latest version of the Terraform Cloud Operator to it. This allows the build to take place locally using any container software (Podman, Docker, Moby, etc), allowing for rootless containers, while Docker runs in the Minikube VM.

```
minikube start --vm-driver=kvm2 --container-runtime=docker --insecure-registry "10.0.0.0/24"
minikube addons enable registry
cd terraform-k8s # clone Terraform Cloud Operator repo first, if needed

docker system prune -a -f
make dev-docker
docker images |grep k8s-dev
docker tag localhost/terraform-k8s-dev:latest $(minikube ip):5000/terraform-k8s-dev:latest
docker push --tls-verify=false $(minikube ip):5000/terraform-k8s-dev:latest
```

Set up variables used by [terraform-helm](https://github.com/hashicorp/terraform-helm). Clone the repo first, if needed.

```
kubectl create ns test
kubectl create -f example/configmap.yaml -n test
kubectl create -n test secret generic terraformrc --from-file=credentials=${HOME}/.terraformrc
kubectl create -n test secret generic workspacesecrets \
 --from-literal=AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
 --from-literal=AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
 --from-literal=AWS_SESSION_EXPIRATION=${AWS_SESSION_EXPIRATION} \
 --from-literal=AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}
kubectl create -n test secret generic sensitivevars --from-literal=myvar=supersecret

# clear out any caches that might interfere with tests
rm -rf ~/.config/helm ~/.cache/helm ~/.helm ~/.local/share/helm

# copy CRD from terraform-k8s repo into helm repo, if you've made any changes to it
rm -f crds/*
cp ../terraform-k8s/deploy/crds/app.terraform.io_workspaces_crd.yaml crds/app.terraform.io_workspaces_crd.yaml
```

Edit values.yaml to use the test image.

```
   imagePullPolicy: "Never"
   imageK8S: "localhost:5000/terraform-k8s-dev:latest"
```


Install the operator.

```
helm install -n test operator .
kubectl get pods -n test
kubectl logs -f $(kubectl get pods -n test -o name) -n test
```

In another window, open the directory containing this repository. Create the Workspace CR. Changes can be applied as needed using this command.

```
cd tfc-operator-test
kubectl apply -f workspace.yaml -n test
```

When finished testing, clean up.

```
kubectl delete -f workspace.yaml  -n test
helm delete operator-test -n test
minikube delete
```
