# Kubernetes

```xml
It's a container orchestrator with the following features: Autoscale, Fault tolerant with self healing, Load Balancing, auto deployment, cloud neutral 
Cluster -> Master Nodes (Manages Cluster) + Worker Nodes (Runs the application) 

Master Node Components -> API Server, Distribute Database, Scheduler, Controller Manager 
Worker Node Components -> Node Agent, Networking Component, Container Runtime, PODS  

Cluster ->will hold one or more nodes -> will hold one or more pods -> will hold one or more containers 

Service -> ReplicaSets -> Pods -> Containers

AKS (Azure Kubernetes Service)
EKS (Amazon Elastic Kubernetes Service)
GKE (Google Kubernetes Engine) 

Regions- > Scattered across the globe
Zones- > In a particular region the no. of availability zones that are present 

<Run all the commands in the google cloud shell>

kubectl -> full form is Kubernetes Controller

gcloud auth login -> Login to the google cloud shell 
gcloud container clusters get-credentials balaji1974-cluster --zone us-central1-a --project solid-course-258105 -> connect to the cluster

kubectl version -> Will display the version of the kubectl 

kubectl create deployment hello-world-rest-api --image=balaji1974/hello-world-rest-api:0.0.1.RELEASE -> Will deploy the application from the container image to a kubernetes cluster. This will create a deployment, replica set and a pod 

kubectl expose deployment hello-world-rest-api --type=LoadBalancer --port=8080 -> This will expose the deployment to the outside world. This will create a service. 

kubectl get events -> Display all the events that happened in the cloud shell 

kubectl get pods -> Displays all the pods that were created (A pod is a unit of replication on a cluster and will contain one or more containers. A node in the cluster will hold one or more pods. A pod is the smallest deployable unit) 
kubectl get pods -o wide -> Displays the full details of all the pods


kubectl get replicaset -> To display the replica set (A ReplicaSet's purpose is to maintain a stable set of replica Pods running at any given time.)

kubectl get deployment -> To display deployments (Deployments represent a set of multiple, identical Pods with no unique identities. A Deployment runs multiple replicas of your application and automatically replaces any instances that fail or become unresponsive)

kubectl set image deployment hello-world-rest-api hello-world-rest-api=DUMMY_IMAGE:TEST
-> This will create another replica set that will be associated with the image “DUMMY…”

kubectl get service -> To display service. A service will provide an always available external interface to the applications that are running inside the pods. This will bind the external IP to the PODS internal IP automatically so that the user can request the page with the same IP address. 

kubectl explain pods -> Will show the full syntax details of a pod
kubectl describe pod hello-world-rest-api-58ff5dd898-9trh2 -> Will display the full details of the specific pod 

kubectl scale deployment hello-world-rest-api --replicas=3 -> This will scale the pods to keep a maximum of 3 replicas 

kubectl delete pod hello-world-rest-api-58ff5dd898-62l9d -> Delete the pod 
kubectl autoscale deployment hello-world-rest-api --max=10 --cpu-percent=70 -> scale the pod to a max of 10 or cpu % to 70%

kubectl set image deployment hello-world-rest-api hello-world-rest-api=balaji1974/hello-world-rest-api:0.0.2.RELEASE -> Associate a new image to a deployment which will create a new replica set and create a pod associated with it 
kubectl get events --sort-by=.metadata.creationTimestamp -> check what happened sorted by creation timestamp 

kubectl get componentstatuses -> Displays all the component statuses 
kubectl rollout history deployment hello-world-rest-api -> To display the release history 
kubectl set image deployment hello-world-rest-api hello-world-rest-api=balaji1974/hello-world-rest-api:0.0.3.RELEASE --record=true -> This is record the change cause while setting the image to the container 
kubectl rollout undo deployment hello-world-rest-api --to-revision=1 ->This will undo the rollout to the revision we have specified 

kubectl logs hello-world-rest-api-58ff5dd898-6ctr2 -> Display the logs of a specific instance 
kubectl logs -f hello-world-rest-api-58ff5dd898-6ctr2 -> This will follow/tail the logs

kubectl get deployment hello-world-rest-api -o yaml -> View the deployment script in a yaml format 
kubectl get deployment hello-world-rest-api -o yaml > deployment.yaml -> Save the above to a yaml file 
kubectl get service hello-world-rest-api -o yaml > service.yaml -> Save the available services of the application into a yaml file 
kubectl apply -f deployment.yaml -> Apply whatever changes we saved in the deployment yaml file 

kubectl delete all -l app=hello-world-rest-api -> Delete the existing pods, services, deployment & replicaset on the server 
kubectl delete deployment hello-world-rest-api -> Delete the deployment 

kubectl get pods --all-namespaces -> List all pods that are running
kubectl get pods --all-namespaces -l app=hello-world-rest-api -> List filtered by hello-world-rest-api 
kubectl get services --all-namespaces -> List all services that are running

kubectl get services --all-namespaces --sort-by=.spec.type -> sort services by type
kubectl get services --all-namespaces --sort-by=.metadata.name -> sort services by name

kubectl cluster-info -> will give information about the cluster 
kubectl cluster-info dump -> will give detail information about the cluster

kubectl top node -> will give memory information about the cluster 
kubectl top pod -> will give memory information about the pod 

kubectl get services -> will get all services 
kubectl get svc -> short form for get services
kubectl get ev -> short form for get events
kubectl get rs -> short form for get replicaset 
kubectl get ns -> short form for get namespace
kubectl get nodes -> will get nodes 
kubectl get no -> short form for get nodes 
kubectl get pods -> will get pods 
kubectl get po -> short form for pods 

Kubernetes gives service discovery and load balancing for free. It also gives centralized configuration management with the help of Kubernetes configmaps and Ingres. A sample yaml file for defining configmap is as follows: 
apiVersion: v1
kind: ConfigMap
metadata:
  name: game-demo
data:
  # property-like keys; each key maps to a simple value
  player_initial_lives: "3"
  ui_properties_file_name: "user-interface.properties"

  # file-like keys
  game.properties: |
    enemy.types=aliens,monsters
    player.maximum-lives=5    
  user-interface.properties: |
    color.good=purple
    color.bad=yellow
    allow.textmode=true    
 
 
Eg. to consume the configmap in our pod is as follows: 
env:
        # Define the environment variable
        - name: PLAYER_INITIAL_LIVES # Notice that the case is different here
                                     # from the key name in the ConfigMap.
          valueFrom:
            configMapKeyRef:
              name: game-demo          # The ConfigMap this value comes from.
              key: player_initial_lives

 

Infrastructure as code: 
Create Template -> Provision Server -> Install software -> Configure Software -> Deploy App 

Provisioning server can be done by AWS Cloudformation or Terraform
Install software/Configure Software (both are configuration management) and can be done by Chef, Ansible or puppet. 
Deploy App can be done with Jenkins or Azure DevOps.

```