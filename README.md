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

## Best Practises  
```xml
DevOps -> also refered to as CAMS (Culture, Automation, Measurement, Sharing)

Standarization (how things are done with multiple teams must be consistent)
Create Teams with Cross Functional Teams 
Focus on Culture (learning, automation, innovation)
Automation (mindset)
Immutable infrastructure (always provision new server and install things rather than upgrade existing environment)
Dev Prod Parity (to have dev and prod environments as similar as possible)
Self Provisioning (dev team must not wait for ops team to provision environment -just run IaaC scripts)


DevOps is about:
---------------
Continous Planning
Continous Development
Continous Integration
Continous Deployment 
Continous Testing 
Continous Delivery 
Continous Monitoring 
Continous Feedback


DevOps Maturity Signals:
-----------------------
Development Process Questions to ask:
Does every commit trigger automated test and automated code quality checks ?
Is your code continously delivered to production ?
Do you use pair programming ?
Do you use TDD (Test-Driven Development) and BDD (Behavior-Driven Development) ?
Do you have lots of reusable modules ?
Can development team self provision environments ? 
How long does it take to deliver a quick fix to production ? 

Testing Questions to ask:
Is you test fully automated with high quality test data similar production systems ?
Does your build fail when your automated test fails ? 
Are your testing cycles small ? 
Do you have automated non functional tests ?


Deployment Questions to ask:
Dev Prod Parity ? (must be as similar as possible)
Do you use A/B testing* ?  
Do you use Canary Deployments ? 
Can you deploy at a click of a button ? 
Can you rollback at a click of a button ?
Can I provision and release infrastructure at a click of a button ?
Do you use IaaC and version control your infrastructure? 


Monitorning Questions to ask:
Does the team use centralized monitorning system? 
Can development team get access to logs at a click of a button?
Does the team get automated alert if something goes wrong in production ?


Teams and Processes:
Is the team looking to continously improve? 
Does the team have the skills needed for business, development and operations ? 
Does the team track the key DevOps metrics and improve upon them ? 
Does the team have the culture of taking local discoveries and using them to make global improvements? 
 

Note: A/B Testing* - A/B testing, also known as split testing or bucket testing, 
is a method of comparing two versions of a webpage, app, or other digital asset 
to see which one performs better based on a specific goal. I
```


### References:
https://www.udemy.com/course/devops-with-docker-kubernetes-and-azure-devops
