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
5. Run command terraform init
6. Run command terraform plan to check all the services which is going to be made.
7. Run command terraform apply --auto-approve
Within 5 to 10 mins all the resources will get formed. Below are the screenshot related to it:
ECS - <br><br>
![ecs](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/6f47f359-7068-4710-9af0-b521af497240) <br><br>
ECR -  <br><br>
![ecr](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/f562b522-41a6-45ae-b8e0-e46eb9465884) <br><br>
ALB - <br><br>
![alb](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/11801c3b-0175-49c7-806f-f7222208ec7c) <br><br>
EFS - <br><br>
![efs](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/4af57888-e0fb-494a-9b7d-a0a5364c6089) <br><br>

Jenkins can be accessed with DNS  -  <br><br>
When we open jenkins platform there we have to make one pipeline to demonstrate our build. <br><br>
![jenkins](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/d2235acb-b9b4-4699-96d2-886ed1386a63) <br><br>

Trigger the user created pipeline -  <br><br>
![jenkins_build](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/6876cf18-2794-4292-95f1-fc00d6d08773) <br><br>

Jenkins ecs agent is taking sometime to come up and in running state.  <br><br>
![ecs_agents](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/bc26c270-3977-4aac-9a1e-961573f0c6b4) <br><br>

When build gets successful in jenkins then ecs agent container also gets deleted from ecs. <br><br>
![jenkins_success](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/5edc0d5c-3d7d-4fd0-86f6-215f1675adfb) <br><br>
![ecs_agents_success](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/5c09a25b-9a31-4627-9a0c-ae9dcb9c035d) <br><br>

We can also exec into the jenkins controller by running below command -  <br><br>
aws ecs execute-command --cluster jenkins-serverless-controller --task arn:aws:ecs:us-east-1:130536001854:task/jenkins-serverless-controller/27e9d765e17b4bf99d464dc343f33d50  --container jenkins-serverless --interactive --command "/bin/sh" <br><br>
![image](https://github.com/Baranwalsahil/ecs-fargate-jenkins/assets/48612626/d952b2fd-1939-402a-843c-a8701a5a6dd4)







