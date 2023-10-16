# Azure Devops

### Create an Azure account 
```xml
Search for "Azure free tier" and click the link. For me the below link appeared. 
https://azure.microsoft.com/en-us/free

Click on Free Account and create the account (note CC is needed for this process)

Once the registration is complete, click on "Go to Azure Portal"
The url is: 
https://portal.azure.com/

First thing is create a budget under subscription so that you can be alerted on the cost. 

```

### Azure DevOps - Initial Setup 
```xml
Search for Azure DevOps Services -> Go the page and click on "Start Free"
Next click on the user settings (in the right corner) -> Click on preview features -> Mutlistage pipelines -> Enable (this was not shown in my profile - newer systems dont show this as it is already an inbuilt feature)
Create new Project -> azure-devops-k8s-terraform -> private project -> create project
Pipelines (From left menu) -> Pipelines -> Create Pipelines 

```

### Setting up Github 
```xml
1. Create a private repository in Github 
eg. I created a repo called 'azure-devops-k8s-terraform'

2. Created the same folder in your local file system and copy the contents of the project hello-world into this folder 'azure-devops-k8s-terraform'

3. Go into this folder and excute the following commands: (for details on using git check my Git Project)
git init 
git add *
git add .
git add .gitignore 
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/balaji1974/azure-devops-k8s-terraform.git
git push -u origin main

```

### Setting up Github in your pipeline
```xml
1. Go to your Azure DevOps workspace
2. Go to your workspace -> Select the project 
3. Click on Pipelines -> Select Github -> Select your repository 'azure-devops-k8s-terraform'
4. Click Starter YAML -> Rename the YAML file as 01-first-azure-pipeline.yml -> Save & Run
5. Commit to master branch -> Now if we refresh the Github we can see the yaml file being pushed. 
6. Click on the job and we can see the complete details of the job 
7. If we click the pipelines -> Click the recent run pipeline -> Click on it and get inside -> Click Run pipeline
8. This will run the pipeline once more 

```

### Typical pipeline in Azure
```xml
Pipeline -> Stages (eg. Prod, Test, Dev etc) -> Jobs (consist of mulitple Jobs) -> Tasks (These are single or multiple stepts)

```

### Looking at the YAML in your pipeline
```xml
1. Pipelines -> Select your pipeline -> More Options -> Edit

Eg. 
****** START ******
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
- main

pool:
  vmImage: ubuntu-latest

steps:
- script: echo Hello, world!
  displayName: 'Run a one-line script'

- script: |
    echo Add other tasks to build, test, and deploy your project.
    echo See https://aka.ms/yaml
  displayName: 'Run a multi-line script'

****** END ******

trigger:
- main -> This will trigger the build when any change happens on the main branch

pool:
  vmImage: ubuntu-latest -> Use an Ubuntu latest image as an agent to run the build

steps: -> To run scripts
- script: echo Hello, world!
  displayName: 'Run a one-line script' -> To run single line scripts

- script: |
    echo Add other tasks to build, test, and deploy your project.
    echo See https://aka.ms/yaml
  displayName: 'Run a multi-line script' -> To run multiline scripts
```

### Creating multiple jobs in the pipeline 
The running order of the job is totally random 

```xml
Eg. 
****** START ******
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
- main

pool:
  vmImage: ubuntu-latest

jobs:
  - job: Job1
    steps:
    - script: echo Job1 Hello, world!
      displayName: 'Run a one-line script'
    - script: |
        echo Add other tasks to build, test, and deploy your project.
        echo See https://aka.ms/yaml
      displayName: 'Run a multi-line script'
  - job: Job2
    steps:
    - script: echo Job2 Hello, world!
      displayName: 'Run a one-line script'

****** END ******

Save -> Run and multiple jobs will be run 

```

### Adding dependsOn to sequence the job running order 
```xml
The below script will run Job2 and then Job3 and then finally Job1

****** START ******
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
- main

pool:
  vmImage: ubuntu-latest

jobs:
  - job: Job1
    dependsOn: Job3
    steps:
    - script: echo Job1 Hello, world!
      displayName: 'Run a one-line script'
    - script: |
        echo Add other tasks to build, test, and deploy your project.
        echo See https://aka.ms/yaml
      displayName: 'Run a multi-line script'
  - job: Job2
    steps:
    - script: echo Job2 
      displayName: 'Run a one-line script'
  - job: Job3
    dependsOn: Job2
    steps:
    - script: echo Job3 
      displayName: 'Run a one-line script'
****** END ******

dependsOn: 
	- Job2
	- Job3 
-> this is also possible 

```

### Stages 
```xml
1. Create a new pipeline called 02-understanding-stages
2. Check the script below for stages
****** START ******
trigger:
- main

pool:
  vmImage: ubuntu-latest

stages: 
  - stage: Build
    jobs:
      - job: FirstJob
        steps: 
        - bash: echo Build FirstJob
      - job: SecondJob
        steps: 
        - bash: echo Build SecondJob
  - stage: DevDeploy
    dependsOn: Build
    jobs:
      - job: DevDeployJob
        steps: 
        - bash: echo DevDeployJob
  - stage: QADeploy
    dependsOn: Build
    jobs:
      - job: QADeployJob
        steps: 
        - bash: echo QADeployJob
  - stage: ProdDeploy
    dependsOn: 
    - DevDeploy
    - QADeploy
    jobs:
      - job: ProdDeployJob
        steps: 
        - bash: echo ProdDeployJob
****** END ******
(At stages level)
dependsOn: 
	- DevDeploy
	- QADeploy 
-> this is also possible 

```

### Stopping other pipelines from running
```xml
Whenever a change happens on one pipeline, other pipeline are also run
To prevent this, click the pipeline -> Edit -> Settings -> Disable 

```

### Variables 
```xml
We can define pipeline level variables. 
Select the pipleline -> Click edit -> Click Variable -> New Variable -> enter the name and the value of the variable
Eg. 
Name: PipelineLevelVariable
Value: PipelineLevelValue

To use this variable do the following in your script
- bash: echo $(PipelineLevelVariable)

At the stage level we can define a variable like this: 
 - stage: DevDeploy
    variables: 
      environment: Dev 

To use this variable do the following in your script 
- bash: echo  $(environment)DeployJob

Predefined variables:
-------------------- 
https://learn.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=azure-devops&tabs=yaml

Check the below code: 
****** START ******
trigger:
- main

pool:
  vmImage: ubuntu-latest

stages: 
  - stage: Build
    jobs:
      - job: FirstJob
        steps: 
        - bash: echo Build FirstJob
        - bash: echo $(PipelineLevelVariable)
        - bash: echo $(Build.BuildNumber)
        - bash: echo $(Build.BuildId)
        - bash: echo $(Build.SourceBranchName)
        - bash: echo $(Build.SourcesDirectory)
        - bash: echo $(System.DefaultWorkingDirectory)
        - bash: ls -R $(System.DefaultWorkingDirectory)
        - bash: echo $(Build.ArtifactStagingDirectory)
****** END ******

Save and Run
```

### Other commands 
```xml
To check software versions: 
--------------------------
****** START ******
trigger:
- main

pool:
  vmImage: ubuntu-latest

stages: 
  - stage: Build
    jobs:
      - job: FirstJob
        steps: 
        - bash: echo Build FirstJob
        - bash: java -version
        - bash: node --version
        - bash: python --version
        - bash: mvn -version
****** END ******
where 
- bash: java -version -> Prints the version of the software on the shell

To copy files: 
--------------
****** START ******
trigger:
- main

pool:
  vmImage: ubuntu-latest

stages: 
  - stage: Build
    jobs:
      - job: FirstJob
        steps: 
        - bash: ls -R $(Build.ArtifactStagingDirectory)
        - task: CopyFiles@2
          inputs:
            SourceFolder: '$(System.DefaultWorkingDirectory)'
            Contents: |
              **/*.yaml
              **/*.tf
            TargetFolder: '$(Build.ArtifactStagingDirectory)'
        - bash: ls -R $(Build.ArtifactStagingDirectory)
****** END ******


Publish artifacts to be used by other stages
--------------------------------------------
(Publish build artifacts)
****** START ******
trigger:
trigger:
- main

pool:
  vmImage: ubuntu-latest

stages: 
  - stage: Build
    jobs:
      - job: FirstJob
        steps: 
        - task: PublishBuildArtifacts@1
          inputs:
            PathtoPublish: '$(Build.ArtifactStagingDirectory)'
            ArtifactName: 'drop'
            publishLocation: 'Container'
****** END ******

```

### Building Strategy - Building for multiple OS
```xml
****** START ******
trigger:
- main

strategy:
  matrix:
    linux:
      imageName: 'ubuntu-latest'
    mac:
      imageName: 'macOS-latest'

pool:
  vmImage: $(imageName)

steps:
- script: echo Running image from $(imageName)
  displayName: 'Run a one-line script'
****** END ******

```

### Deployment Jobs
```xml
****** START ******
trigger:
- main

pool:
  vmImage: ubuntu-latest

stages: 
  - stage: Build
    jobs:
      - job: BuildJob
        steps: 
        - bash: echo "Do the build"
  - stage: DevDeploy
    jobs:
      - job: DevDeployJob
        steps: 
        - bash: echo "Start Dev deploy"
      - deployment: DevDeploy
        environment: Dev
        strategy:
          runOnce:
            deploy:
              steps:
              - bash: echo "Deploy to Dev"
  - stage: QADeploy
    jobs:
      - job: QADeployJob
        steps: 
        - bash: echo "Start QA deploy"
      - deployment: QADeploy
        environment: QA
        strategy:
          runOnce:
            deploy:
              steps:
              - bash: echo "Deploy to QA"

****** END ******

3 stages are present here -> Build, DevDeploy and QADeploy
2 environments are created under the deployement of DevDeploy and QADeploy namely Dev and QA
After build stage approval is needed for DevDeploy and once it is completed approval is needed for QADeploy

```

### Build and push docker image
```xml
1. Create a connection to the docker hub
Project Settings -> Pipelines -> Service Connection -> New Service connection -> Search "Docker" -> Docker Registry -> Next -> Select Docker Hub 
Enter your Docker Id: <test>
Enter your Docker Pwd: <test> 
Verify and Save 

2. Create a new pipeline -> Github -> Select your repository -> Docker -> $(Build.SourcesDirectory)/Dockerfile -> Validate and configure

3. In the review your pipeline page -> in the middle of the script file, look for settings and click on it 
Select your container registry 
Enter your container repository 
Command -> Build and Push -> Add
Upon clicking add a new " - task: Docker@2" is created. So remove the old "-task:" section 
Eg. 
****** START ******
trigger:
- main

resources:
- repo: self

variables:
  tag: '$(Build.BuildId)'

stages:
- stage: Build
  displayName: Build image
  jobs:
  - job: Build
    displayName: Build
    pool:
      vmImage: ubuntu-latest
    steps:
    - task: Docker@2
      inputs:
        containerRegistry: 'Azure-Docker-Hub'
        repository: 'balaji1974/hello-world'
        command: 'buildAndPush'
        Dockerfile: '**/Dockerfile'
        tags: '$(tag)'
****** END ******
(Note: for this to work add target/your-final-build.jar file in the github source folder)

```

### Azure Releases Pipelines
```xml
To enable release pipeline -> To to Organization settings -> Pipelines -> Settings -> 
Disable creation of classic release pipelines -> Switch this 'on'

Next create a new artifact pipeline (like in example 04-other-commands)
****** START ******
trigger:
- main

pool:
  vmImage: ubuntu-latest

stages: 
  - stage: Build
    jobs:
      - job: FirstJob
        steps: 
        - bash: ls -R $(Build.ArtifactStagingDirectory)
        - task: CopyFiles@2
          inputs:
            SourceFolder: '$(System.DefaultWorkingDirectory)'
            Contents: |
              **/*.yaml
              **/*.tf
            TargetFolder: '$(Build.ArtifactStagingDirectory)'
        - bash: ls -R $(Build.ArtifactStagingDirectory)
        - task: PublishBuildArtifacts@1
          inputs:
            PathtoPublish: '$(Build.ArtifactStagingDirectory)'
            ArtifactName: 'drop'
            publishLocation: 'Container'
****** END ******

Save this pipeline as 08-release-pipeline
Next do the following:
Pipeline -> Releases -> New Pipeline -> Click select an empty job -> Add an artifact -> Select your current project -> Select your 08-release-pipeline -> Add -> Click the "Lightning symbol" -> Enable Continuous deployment trigger -> Save (to a folder \release)

Add Stages -> Dev -> then save -> Click on the Dev stage -> Add task (within this stage) -> Agent Job -> Agent Pool (Azure Pipelines) Agent Specification (ubuntu latest) -> Next Search Bash -> Add Bash Script -> 
Display Name : ListFiles
Script: ls -R $(System.ArtifactsDirectory)

Rename the pipeline to: List-File-Release-Pipeline
Go back to pipeline -> Create a release -> Save -> Click the Release -> Deploy and run 

Next Edit the release pipeline -> Select the stages -> Clone the stage -> Edit the name (to QA) -> Save -> Click the lightning (pre-deployment conditions) -> Select (after stage dev) -> Select the Pre deployment approver -> Enter your name/email id -> Save

Next goto the pipeline -> Select 08-release-pipeline -> Run pipeline 
Next goto the release pipeline -> A new release will be automatically triggered from the pipeline 
Here QA stage will wait for approval -> Approve -> This will tigger the QA release 

Note: Variables can also be configured with different values for different release scopes  


https://learn.microsoft.com/en-us/azure/devops/pipelines/release/variables?view=azure-devops&tabs=batch

```

### 
```xml

```


### References:
```xml
https://devblogs.microsoft.com/devops/announcing-general-availability-of-azure-pipelines-yaml-cd/
https://www.udemy.com/course/devops-with-docker-kubernetes-and-azure-devops
```
