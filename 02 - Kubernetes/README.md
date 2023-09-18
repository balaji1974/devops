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

```

## K8S architecture

```xml
Containers -> reside inside Pod
Pods -> sit on Replica Set
Replica Set -> sit on Deployment   

Master nodes -> Manage the cluster. It consist of the following componenets ->  API Server [kube-apiserver], Distribute Database [etcd], Scheduler [kube-scheduler], Controller Manager [kube-controller-manager]
Worker nodes -> Manage the application. It consist of the following components -> Node Agent [kubelet], Networing Component [kube-proxy], Container runtime [docker, etc], Pods [mulitple pods running the containers]

```


## K8S Commands for reference 

```xml
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

```

## Kubernetes import commands 
```xml
docker run -p 8080:8080 in28min/hello-world-rest-api:0.0.1.RELEASE

kubectl create deployment hello-world-rest-api --image=in28min/hello-world-rest-api:0.0.1.RELEASE
kubectl expose deployment hello-world-rest-api --type=LoadBalancer --port=8080
kubectl scale deployment hello-world-rest-api --replicas=3
kubectl delete pod hello-world-rest-api-58ff5dd898-62l9d
kubectl autoscale deployment hello-world-rest-api --max=10 --cpu-percent=70
kubectl edit deployment hello-world-rest-api #minReadySeconds: 15
kubectl set image deployment hello-world-rest-api hello-world-rest-api=in28min/hello-world-rest-api:0.0.2.RELEASE

gcloud container clusters get-credentials in28minutes-cluster --zone us-central1-a --project solid-course-258105
kubectl create deployment hello-world-rest-api --image=in28min/hello-world-rest-api:0.0.1.RELEASE
kubectl expose deployment hello-world-rest-api --type=LoadBalancer --port=8080
kubectl set image deployment hello-world-rest-api hello-world-rest-api=DUMMY_IMAGE:TEST
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl set image deployment hello-world-rest-api hello-world-rest-api=in28min/hello-world-rest-api:0.0.2.RELEASE
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get componentstatuses
kubectl get pods --all-namespaces

kubectl get events
kubectl get pods
kubectl get replicaset
kubectl get deployment
kubectl get service

kubectl get pods -o wide

kubectl explain pods
kubectl get pods -o wide

kubectl describe pod hello-world-rest-api-58ff5dd898-9trh2

kubectl get replicasets
kubectl get replicaset

kubectl scale deployment hello-world-rest-api --replicas=3
kubectl get pods
kubectl get replicaset
kubectl get events
kubectl get events --sort-by=.metadata.creationTimestamp

kubectl get rs
kubectl get rs -o wide
kubectl set image deployment hello-world-rest-api hello-world-rest-api=DUMMY_IMAGE:TEST
kubectl get rs -o wide
kubectl get pods
kubectl describe pod hello-world-rest-api-85995ddd5c-msjsm
kubectl get events --sort-by=.metadata.creationTimestamp

kubectl set image deployment hello-world-rest-api hello-world-rest-api=in28min/hello-world-rest-api:0.0.2.RELEASE
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get pods -o wide
kubectl delete pod hello-world-rest-api-67c79fd44f-n6c7l
kubectl get pods -o wide
kubectl delete pod hello-world-rest-api-67c79fd44f-8bhdt

kubectl get componentstatuses
kubectl get pods --all-namespaces

gcloud auth login
kubectl version
gcloud container clusters get-credentials in28minutes-cluster --zone us-central1-a --project solid-course-258105

kubectl rollout history deployment hello-world-rest-api
kubectl set image deployment hello-world-rest-api hello-world-rest-api=in28min/hello-world-rest-api:0.0.3.RELEASE --record=true
kubectl rollout undo deployment hello-world-rest-api --to-revision=1

kubectl logs hello-world-rest-api-58ff5dd898-6ctr2
kubectl logs -f hello-world-rest-api-58ff5dd898-6ctr2

kubectl get deployment hello-world-rest-api -o yaml
kubectl get deployment hello-world-rest-api -o yaml > deployment.yaml
kubectl get service hello-world-rest-api -o yaml > service.yaml
kubectl apply -f deployment.yaml
kubectl get all -o wide
kubectl delete all -l app=hello-world-rest-api

kubectl get svc --watch
kubectl diff -f deployment.yaml
kubectl delete deployment hello-world-rest-api
kubectl get all -o wide
kubectl delete replicaset.apps/hello-world-rest-api-797dd4b5dc

kubectl get pods --all-namespaces
kubectl get pods --all-namespaces -l app=hello-world-rest-api
kubectl get services --all-namespaces
kubectl get services --all-namespaces --sort-by=.spec.type
kubectl get services --all-namespaces --sort-by=.metadata.name
kubectl cluster-info
kubectl cluster-info dump
kubectl top node
kubectl top pod
kubectl get services
kubectl get svc
kubectl get ev
kubectl get rs
kubectl get ns
kubectl get nodes
kubectl get no
kubectl get pods
kubectl get po

kubectl delete all -l app=hello-world-rest-api
kubectl get all

kubectl apply -f deployment.yaml 
kubectl apply -f ../currency-conversion/deployment.yaml

```

## Create and manage Kubernetes cluster on google cloud 

```xml
1. Create a cluster 
Search for Kubernetes -> Create -> GKE Standard (later we will see for managed - GKE Autopilot) -> Enter cluster name -> Leave other parameters to default -> Create  

2. Activate Cloud Shell 
Click on the cluster -> Activate cloud shell -> Open in new window 

3. Connect to the cluster 
Click on the cluster -> Connect -> Copy and paste the below command on cloud shell open in the previous window
gcloud container clusters get-credentials <cluster name> --zone <zone> --<project name>

4. Check the kubernetes version
kubectl version


```

# Steps for creating a K8S cluster on GCP 

## Step 1 - Create a private VPC network 
```xml
VPC Network -> Create a VPC network -> 
Name: test-cluster-01
Subnets -> Subnet creation mode -> Custom -> Add Subnet 
New Subnet -> 
  Name: test-cluster-01
  Region: asia-south1
  IP ranges: 10.0.0.0/24 (this will support 2^8 = 256 local ip addresses)
(leave all others to default)
click create 
```

## Step 2 - Create cloud NAT (to authorize services like MongoDB using fixed IP address from ) 
```xml
Cloud NAT -> Create Cloud NAT Gateway 
Gateway Name: test-cluster-01
Select Cloud Router 
  Network: test-cluster-01 (previously created VPC Network)
  Region: asia-south1 (same as the VPC network)
  Cloud Router: Create New Router 
    Name: test-cluster-01 
    (Leave all others to default)
    Create 
  Cloud NAT Mapping
    Cloud NAT IP addresses: Manual 
    IT Addresses
      Network Service Tier: Premium 
        IP address 1 -> Create IP Address
          Name: test-cluster-01
          Click Reserve
(leave all others to default)
click Create 

Once the NAT is created, click it and go inside to look for the static IP address that will be used by outside cloud services to authenticate the request that originate from this cluster 
```

## Step 3 - Setting up a kubernetes autopilot cluster on GCP 
```xml
Menu -> Kubernetes Engine -> Clusters -> Create 
Autopilot -> Configure
Name: test-cluster-01
Region: asia-south1
Click Networking 

Network: test-cluster-01 (same VPC network created in step 2)
Node subnet: test-cluster-01 (same subnet created in step 2)
IPv4 network access: Private cluster
Access control plane using its external IP address: This must be ticked 

Add authorized network (to access this cluster)
New authorized network
  Name: MyHome
  Network: 52.39.207.171/32 (eg. IP address of my home)

Next: Advance Settings -> Next: Review and Create -> Create cluster 

```

## Step 4 - Adding firewall rules for outbound ports ourside of the cluster (Eg. Managed MongoDB Atlas)
```xml
 --- Nothing to do inside GCP here ---
Add the external static IP address created in the step 2 into the MongoDB Atlas allowed Network Access List  
```



## Step 5 - Build the application and push it to the GCP artifact registry  
```xml
1. Go to the project root directory (in my case)
cd /Users/balaji.thiagarajan/eclipse-workspace/hello-world

2. Maven clean and build the project
mvn clean install  -DskipTests
where the pom,xml contains the following configuration parameters
<groupId>com.balaji.etl</groupId>
<artifactId>hello-world</artifactId>
<version>0.0.1-SNAPSHOT</version>
<name>hello-world</name>
<description>Demo project for Spring Boot</description>
<properties>
  <java.version>17</java.version>
</properties>

3. Build the docker file to be pushed to the GCP artifact registry (note: not to the docker hub)
docker build --platform=linux/amd64 -t asia-south1-docker.pkg.dev/balaji-test-343516/hello-world/hello-world:0.0.1-SNAPSHOT .                               
Note: 
--platform=linux/amd64 is the target K8S platform where the container must be deployed
asia-south1-docker.pkg.dev where asia-south1 is where the registry is present 
balaji-test-343516 is the project id of my GCP project
hello-world is the docker container name and it must be created first inside the artifact registry 
hello-world:0.0.1-SNAPSHOT is the container image  

The Dockerfile used for this build is as below: 
FROM openjdk:17-alpine 
EXPOSE 8080
ADD target/hello-world-0.0.1-SNAPSHOT.jar hello-world-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "/hello-world-0.0.1-SNAPSHOT.jar"]

4. Run the docker file locally to check if everything is correct or not 
docker run -p 8080:8080 --name hello-world hello-world

5. Give access rights for reading and writing into the artifact registry (but create the container folder hello-world first from GCP console)
gcloud artifacts repositories add-iam-policy-binding hello-world --location=asia-south1 --member=user:<your user id/>  --role="roles/artifactregistry.writer
or (in case of a service account - advisable)
gcloud artifacts repositories add-iam-policy-binding ${PROJECT} --member=serviceAccount:${EMAIL} --role=roles/ artifactregistry.writer

6. Authenticte to your gcloud repository for docker 
gcloud auth configure-docker asia-south1-docker.pkg.dev

7. Push the image to gcloud artifact registry 
docker push --platform=linux/amd64 asia-south1-docker.pkg.dev/balaji-test-343516/hello-world/hello-world:0.0.1-SNAPSHOT

```

## Step 6 - Deploy the container on the K8S environment 
```xml
1. Run this command to install all the tools needs to run kubectl commands from local PC 
gcloud components install gke-gcloud-auth-plugin 

2. Verify the installation
gke-gcloud-auth-plugin --version 

3. Connect to cluster (differs for users-project-cluster combination)-> Get this command from your K8S cluster in GCP console 
gcloud container clusters get-credentials test-cluster-01 --region asia-south1 --project balaji-test-343516

4. Deploy a container 
kubectl create deployment hello-world --image=asia-south1-docker.pkg.dev/balaji-test-343516/hello-world/hello-world:0.0.1-SNAPSHOT

5.Expose a deployment
kubectl expose deployment hello-world --type=LoadBalancer --port=8080

6. Check the pods
kubectl get pods -o wide 

7. Check the services
kubectl get services

8. Check the logs of the pod (in attached mode) 
kubectl logs -f <pod-id>

9. Scale deployment
kubectl scale deployment hello-world --replicas=3 

10. Check replica set
kubectl get rs 

11. Delete everything related to this pod 
kubectl delete all -l app=hello-world

```

## Reference:
```xml
https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/
https://www.udemy.com/course/devops-with-docker-kubernetes-and-azure-devops/
https://dchaykin.medium.com/connect-a-gke-cluster-with-mongodb-atlas-through-cloud-nat-b0ffb2683b7d
https://www.mongodb.com/developer/products/atlas/connect-atlas-cloud-kubernetes-peering/#step-4--deploy-containers-and-test-connectivity
```

