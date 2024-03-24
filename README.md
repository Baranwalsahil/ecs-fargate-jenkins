# ecs-fargate-jenkins
In this project, jenkins have been deployed on ecs fargate using terraform scripts. Whenever a user submits a jenkins build then jenkins spins a tasks on ecs(jenkins agent) and as soon as builds get finished then the containers exits out.
Assumptions - Domain has already been registered in the route 53.
For running this project on your local:
1. Terraform should be installed.
2. Your aws credentials should have required iam permission for accessing aws services such as:<br>
    a. EFS<br>
    b. LoadBalancer<br>
    c. ECS<br>
    d. ECR<br>
    e. CloudMap<br>
    f. Route53<br>
    g. VPC<br>
3. Clone the repository - git clone https://github.com/Baranwalsahil/ecs-fargate-jenkins.git
4. Now change the directory to jenkins-ecs
5. Run command terraform plan to check all the services which is going to be made.
6. Run command terraform apply --auto-approve
Within 5 to 10 mins all the resources will get formed. Below are the screenshot related to it:
ECS - 
![ecs](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/6f47f359-7068-4710-9af0-b521af497240)
ECR - 
![ecr](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/f562b522-41a6-45ae-b8e0-e46eb9465884)
ALB -
![alb](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/11801c3b-0175-49c7-806f-f7222208ec7c)
EFS -
![efs](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/4af57888-e0fb-494a-9b7d-a0a5364c6089)

Jenkins can be accessed with DNS  - 
When we open jenkins platform there we have to make one pipeline to demonstrate our build.
![jenkins](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/d2235acb-b9b4-4699-96d2-886ed1386a63)

Trigger the user created pipeline - 
![jenkins_build](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/6876cf18-2794-4292-95f1-fc00d6d08773)

Jenkins ecs agent is taking sometime to come up and in running state. 
![ecs_agents](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/bc26c270-3977-4aac-9a1e-961573f0c6b4)

When build gets successful in jenkins then ecs agent container also gets deleted from ecs.
![jenkins_success](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/5edc0d5c-3d7d-4fd0-86f6-215f1675adfb)
![ecs_agents_success](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/5c09a25b-9a31-4627-9a0c-ae9dcb9c035d)






