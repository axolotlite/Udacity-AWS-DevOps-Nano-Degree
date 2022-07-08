# Project Title - Deploy a high-availability web app using CloudFormation
### Introduction
In this project, I was tasked with deploying web servers for a highly available web app using CloudFormation. I have drawn a cloud diagram and written the cloudformation code that creates and deploys the infrastructure and application. I've began by deploying the networking components, followed by servers, security roles and software. Hoepfully this procedure strengthens my portfolio.
### Server Specifications
The auto-scaling group creates 4-6 servers spread evenly into 2 private subnets. Each private subnet is routed to a public subnet connected to the internet. I've opted to use a main route table connecting all subnets to allow a bastion host to ssh into any EC2 Instance present in either of the subnets.
### The Cloud Diagram
![Alt text](/images/AWS_related_diagram.drawio.png "Cloud Diagram for High Availability Web Apps")

#### Scripts Usage
parameterize: interactive parameter setter for yml files 
without an optional output name, the script creates a parameters.json file
```
./parameterize.sh file.yml (optional-parameter-name)
```
create.sh: will by default target project2.yml and parameters.json then create a stack named "UdacityProject"
however you can manually specify its parameters if you want.
```
./create.sh (optional-stack-name) (optional-stack-file) (optional-stack-parameters)
```
## [My Load Balancer DNS URL](http://Udaci-Elast-EIJS1ZBKIRWB-19340612.us-east-1.elb.amazonaws.com)