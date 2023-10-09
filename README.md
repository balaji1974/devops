# Devops

## 3 Key Elements of a Great Software: 
```xml
Enhanced communication.  
Automation.  
Quick Feedback. 
```

## Agile 
```xml
(Brings business and development teams together and immediate feedback is given at the end of each sprint)
Involves business teams and development teams   
Quick Feedback.   
Continuous Integration. 
```    

## Microservices 
```xml
As they evolved Operations team had a big role to play.   
DevOps evolved.  
``` 

## DevOps 
```xml
Enhance communication between Development & Operations teams.  
Continuous Deployment (deploy new version of software continuously).  
Continuous Delivery (deploy software into production continuously).  
```   
  
## Infrastructure as Code
```xml
Continuous Development: Git, SVN, Mercurial, CVS, Jira   
Continuous Integration: Jenkins, Bamboo, Hudson    
Continuous Delivery: Nexus, Archiva, Tomcat   
Continuous Deployment: Puppet, Chef, Docker   
Continuous Monitoring: Splunk, ELK Stack, Nagios     
Continuous Testing: Selenium, Katalon Studio   
```

## Infrastructure as code - Process: 
```xml   
Create Template -> Provision Server -> Install software -> Configure Software -> Deploy App    

Provisioning server can be done by AWS Cloudformation or Terraform    
Install software/Configure Software (both are configuration management) and can be done by Chef, Ansible or puppet.     
Deploy App can be done with Jenkins or Azure DevOps. 
```  

## Continous Integration  
```xml
Code Commit -> Unit Test -> Code Quality -> Package -> Integration Test 
```

## Continous Deployment 
```xml
Code Commit -> Unit Test -> Code Quality -> Package -> Integration Test-> Package -> Deploy -> Automated Test 
```

## Continous Delivery  
```xml
Code Commit -> Unit Test -> Code Quality -> Package -> Integration Test-> Package -> Deploy -> Automated Test -> Test Approval -> Deploy to be next environment 
```


### References:
https://www.udemy.com/course/devops-with-docker-kubernetes-and-azure-devops
