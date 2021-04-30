resource "aws_iam_instance_profile" "ecs_profile" {
    depends_on = [ aws_iam_role.ecs_role]
    name_prefix = "ecs_instance_profile"
    role        = aws_iam_role.ecs_role.name
}

resource "aws_iam_role" "ecs_role" {
    name_prefix = "ecs_role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
        "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com"]
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
    EOF
}

resource "aws_iam_policy" "ecs_policy" {
    name_prefix = "ecs_policy"
    path        = "/"
    description = "A terraform created policy for ECS"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
            "ecs:CreateCluster",
            "ecs:DeregisterContainerInstance",
            "ecs:DiscoverPollEndpoint",
            "ecs:Poll",
            "ecs:RegisterContainerInstance",
            "ecs:StartTelemetrySession",
            "ecs:Submit*",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "*"
        }
    ]
}
    EOF
}

resource "aws_iam_policy_attachment" "attach_ecs" {
    depends_on = [ aws_iam_role.ecs_role, aws_iam_policy.ecs_policy ]
    name       = "ecs_iam_attach"
    roles      = [ aws_iam_role.ecs_role.name ]
    policy_arn = aws_iam_policy.ecs_policy.arn
}

#--------------------Task definition-----------------------#

resource "aws_iam_role" "ecs-task-execution-role" {
    name_prefix = "ecs_taskexec_role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
        "Service": ["ecs-tasks.amazonaws.com"]
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
    EOF
}

resource "aws_iam_policy" "ecs_task_exec_policy" {
    name_prefix = "ecs_task_exec_policy"
    path        = "/"
    description = "A terraform created policy for ECS"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "*"
        }
    ]
}
    EOF
}

resource "aws_iam_policy_attachment" "attach_ecs_task_exec" {
    depends_on = [ aws_iam_role.ecs-task-execution-role, aws_iam_policy.ecs_task_exec_policy ]
    name       = "ecs_task_exec_iam_attach"
    roles      = [ aws_iam_role.ecs-task-execution-role.name ]
    policy_arn = aws_iam_policy.ecs_task_exec_policy.arn
}

#-----------------------Service--------------------------#

resource "aws_iam_role" "ecs-service-role" {
    name_prefix = "ecs_service_role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
        "Service": ["ecs.amazonaws.com"]
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
    EOF
}

resource "aws_iam_policy" "ecs_service_policy" {
    name_prefix = "ecs_service_policy"
    path        = "/"
    description = "A terraform created policy for ECS"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ECSTaskManagement",
            "Effect": "Allow",
            "Action": [
                "ec2:AttachNetworkInterface",
                "ec2:CreateNetworkInterface",
                "ec2:CreateNetworkInterfacePermission",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteNetworkInterfacePermission",
                "ec2:Describe*",
                "ec2:DetachNetworkInterface",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:RegisterTargets",
                "route53:ChangeResourceRecordSets",
                "route53:CreateHealthCheck",
                "route53:DeleteHealthCheck",
                "route53:Get*",
                "route53:List*",
                "route53:UpdateHealthCheck",
                "servicediscovery:DeregisterInstance",
                "servicediscovery:Get*",
                "servicediscovery:List*",
                "servicediscovery:RegisterInstance",
                "servicediscovery:UpdateInstanceCustomHealthStatus"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AutoScaling",
            "Effect": "Allow",
            "Action": [
                "autoscaling:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AutoScalingManagement",
            "Effect": "Allow",
            "Action": [
                "autoscaling:DeletePolicy",
                "autoscaling:PutScalingPolicy",
                "autoscaling:SetInstanceProtection",
                "autoscaling:UpdateAutoScalingGroup"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "autoscaling:ResourceTag/AmazonECSManaged": "false"
                }
            }
        },
        {
            "Sid": "AutoScalingPlanManagement",
            "Effect": "Allow",
            "Action": [
                "autoscaling-plans:CreateScalingPlan",
                "autoscaling-plans:DeleteScalingPlan",
                "autoscaling-plans:DescribeScalingPlans"
            ],
            "Resource": "*"
        },
        {
            "Sid": "CWAlarmManagement",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DeleteAlarms",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:PutMetricAlarm"
            ],
            "Resource": "arn:aws:cloudwatch:*:*:alarm:*"
        },
        {
            "Sid": "ECSTagging",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags"
            ],
            "Resource": "arn:aws:ec2:*:*:network-interface/*"
        },
        {
            "Sid": "CWLogGroupManagement",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:DescribeLogGroups",
                "logs:PutRetentionPolicy"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/ecs/*"
        },
        {
            "Sid": "CWLogStreamManagement",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/ecs/*:log-stream:*"
        },
        {
            "Sid": "ExecuteCommandSessionManagement",
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeSessions"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ExecuteCommand",
            "Effect": "Allow",
            "Action": [
                "ssm:StartSession"
            ],
            "Resource": [
                "arn:aws:ecs:*:*:task/*",
                "arn:aws:ssm:*:*:document/AmazonECS-ExecuteInteractiveCommand"
            ]
        }
    ]
}
    EOF
}

resource "aws_iam_policy_attachment" "attach_ecs_service_exec" {
    depends_on = [ aws_iam_role.ecs-service-role, aws_iam_policy.ecs_service_policy ]
    name       = "ecs_service_iam_attach"
    roles      = [ aws_iam_role.ecs-service-role.name ]
    policy_arn = aws_iam_policy.ecs_service_policy.arn
}