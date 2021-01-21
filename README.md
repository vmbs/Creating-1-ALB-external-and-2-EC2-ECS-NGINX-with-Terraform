# Creating-1-ALB-external-and-2-EC2-ECS-with-Terraform
How to create one Application Load Balancer with external network and 2 instances EC2-ECS with Terraform

First let’s set up our provider: provider.tf

We creates a new VPC: vpc.tf

We have the configuration for the Application Load Balancer: alb.tf

We set the AMI that will update and launch configuration of the cluster: data.tf

Adding the configuration for our ECS cluster: ecs-cluster.tf

And the tpl file: ecs-cluster.tpl

Adding our ECS service and task and Cloud Watch configurations: ecs-nginx.tf

Adding the IAM roles for the EC2 instances so they can communicate with the ECS service: iam.tf

We can see that the load balancer is open to the world on tcp/80 and tcp/443 and the ECS EC2 instances have ports 32768 to 65535 open from the load balancer. This is because when we select the container port to 0 in the task definition AWS will randomly assign a port from this range to the container: security.tf

We have our variables file: vars.tf
