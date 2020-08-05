# secure-inline-scan - using podman
This is a fork of the sysdiglabs/secure-inline-scan repository which has been adapted to use podman instead of docker for the use with OpenShift and Tekton.

This script is useful for performing local analysis on container images (both from registries and locally built) and post the result of the analysis to [Sysdig Secure](https://sysdig.com/products/kubernetes-security/).

## Minimum Requirements
* Sysdig Secure > v2.5.0 access (with token)
* Internet Access to post results to Sysdig Secure

### OnPrem

#### podman
```
podman run --privileged sysdigdan/secure-inline-scan:latest analyze -s <SYSDIG_REMOTE_URL> -o -k <TOKEN> <FULL_IMAGE_NAME>
```
#### docker
```
docker run --privileged sysdigdan/secure-inline-scan:latest analyze -s <SYSDIG_REMOTE_URL> -o -k <TOKEN> <FULL_IMAGE_NAME>
```
### SaaS

#### podman
```
podman run --privileged sysdigdan/secure-inline-scan:latest analyze -k <TOKEN> <FULL_IMAGE_NAME>
```
#### docker
```
docker run --privileged sysdigdan/secure-inline-scan:latest analyze -k <TOKEN> <FULL_IMAGE_NAME>
```

## OpenShift and Tekton
These intsructions assume you have OpenShift up and running.

### Install Tekton
```
oc new-project tekton-pipelines
oc adm policy add-scc-to-user anyuid -z tekton-pipelines-controller
oc apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.notags.yaml
```

#### Optional - Install Tekton Dashbaord
```
oc apply -f https://storage.googleapis.com/tekton-releases-nightly/dashboard/latest/openshift-tekton-dashboard-release.yaml --validate=false
oc get route tekton-dashboard -n tekton-pipelines
```

### Setup OpenShift Project and Service Account
```
oc new-project sysdig-inline-scan
oc create serviceaccount sysdig-account -n sysdig-inline-scan
```

You may need to give the serviceaccount additional privileges to be able to interact with your local registry

Create a secret that your task can reference to access sysdig, setting the 
SYSDIG_SECURE_TOKEN to your secure token
```
oc create secret generic sysdig-secret -n sysdig-inline-scan --from-literal secure-token="${SYSDIG_SECURE_TOKEN}"
```

### Configure Tekton Example Task and TaskRun
Edit the tekton_task.yaml for your environment.

```
      env:
      - name: SYSDIG_SECURE_TOKEN
        value: <TOKEN>
      - name: IMAGE_TO_SCAN
        value: <FULL_IMAGE_NAME>
```

### Deploy and run Tekton Task
```
oc create -f tekton_taskrun.yaml
```






