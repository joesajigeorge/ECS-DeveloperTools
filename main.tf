terraform {

  backend "s3" {
    bucket  = "tf-statefile-store"
    key     = "ecsdevelopertools/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "myaccount"
  }
}

provider "aws" {
    profile = var.awsprofile
    region  = var.region
}

module "vpc" {
    source         = "./modules/vpc"
    env            = var.env
    region         = var.region
    projectname    = var.projectname
    vpc_cidr       = var.vpc_cidr
    public_subnet  = var.public_subnet
    private_subnet = var.private_subnet
}

module "ecs" {
    depends_on     = [ module.vpc ]
    source         = "./modules/ecs"
    env            = var.env
    region         = var.region
    projectname    = var.projectname
    vpc_id         = module.vpc.vpc_id
    ami_version    = var.ami_version
    instance_type  = var.instance_type
    asg_desired    = var.asg_desired
    asg_min        = var.asg_min
    asg_max        = var.asg_max
    public_subnet  = module.vpc.public_subnet_ids
    private_subnet = module.vpc.public_subnet_ids
    ecr_image_uri = var.ecr_image_uri
    container_name = var.container_name
    container_cpu = var.container_cpu
    container_memory = var.container_memory
    container_port = var.container_port
    host_port = var.host_port
    key_pair = var.key_pair
}

module "developerTools" {
    depends_on     = [ module.vpc, module.ecs ]
    source         = "./modules/developerTools"
    env            = var.env
    region         = var.region
    projectname    = var.projectname
    pipeline_artifact_bucket_name = var.pipeline_artifact_bucket_name
    github_oauth_token = var.github_oauth_token
    repo_branch = var.repo_branch
    poll_source_changes = var.poll_source_changes
    code_start_connection_arn = var.code_start_connection_arn
    repo_id = var.repo_id
    ecs-task-execution-role = module.ecs.ecs-task-execution-role
    ecs_role = module.ecs.ecs_role
    aws_lb_target_group_name = module.ecs.aws_lb_target_group_name
    aws_ecs_cluster_name = module.ecs.aws_ecs_cluster_name
    aws_ecs_service_name = module.ecs.aws_ecs_service_name
    aws_alb_listener_arn = module.ecs.aws_alb_listener_arn
}