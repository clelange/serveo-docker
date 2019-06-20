# serveo-tunnel

[![Container layers and size](https://images.microbadger.com/badges/image/clelange/serveo-tunnel.svg)](https://microbadger.com/images/clelange/serveo-tunnel)
[![Container version](https://images.microbadger.com/badges/version/clelange/serveo-tunnel.svg)](https://microbadger.com/images/clelange/serveo-tunnel)

Expose local servers to the internet using [serveo](https://serveo.net) from a docker container for testing endpoints that might otherwise be behind a firewall. Automatically reconnects if connection is lost (in most cases the subdomain should remain the same).

## Building

```shell
docker build --squash -t clelange/serveo-tunnel
```

## Running via Docker

```shell
docker run --rm -it clelange/serveo-tunnel autossh -M 0 -R 80:localhost:8888 serveo.net
```

Use the endpoint that is printed to the terminal for connection.

## Running as Kubernetes pod

Create a pod configuration such as this one (called `serveo-tunnel-pod.yaml`):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: serveo
  labels:
    app: serveo
spec:
  containers:
  - name: serveo-tunnel
    image: clelange/serveo-tunnel
    command: ["autossh", "-M", "0", "-R", "80:jenkins-x-chartmuseum:8080", "chartmuseum@serveo.net"]
  restartPolicy: Never
```

Then apply the configuration to schedule to pod:

```shell
kubectl apply -f serveo-tunnel-pod.yaml
```

And figure out the endpoint:

```shell
kubectl logs pod/serveo
```

Do not forget to delete the pod when not needed anymore:

```shell
kubectl delete pod/serveo
```
