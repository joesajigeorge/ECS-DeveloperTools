resource "aws_iam_role" "default" {
  name               = "${var.projectname}-${var.env}-pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  depends_on = [ aws_iam_role.default, aws_iam_policy.default ]
  role       = aws_iam_role.default.id
  policy_arn = aws_iam_policy.default.arn
}

resource "aws_iam_policy" "default" {
  name   = "${var.projectname}-${var.env}-pipeline-policy"
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "s3:*",
      "iam:PassRole",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codestar-connections:UseConnection",
      "ecs:*",
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role" "build" {
  name = "${var.projectname}-${var.env}-build-role"
  assume_role_policy = data.aws_iam_policy_document.assume_build_role.json
}

data "aws_iam_policy_document" "assume_build_role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "build" {
  depends_on = [ aws_iam_role.build, aws_iam_policy.build ]
  role       = aws_iam_role.build.id
  policy_arn = aws_iam_policy.build.arn
}

resource "aws_iam_policy" "build" {
  name   = "${var.projectname}-${var.env}-build-policy"
  policy = data.aws_iam_policy_document.build.json
}

data "aws_iam_policy_document" "build" {
  statement {
    sid = ""

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "s3:*",
      "codepipeline:*",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}

# data "aws_iam_policy_document" "assume_by_codedeploy" {
#   statement {
#     sid     = ""
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["codedeploy.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role" "codedeploy" {
#   name               = "codedeploy"
#   assume_role_policy = data.aws_iam_policy_document.assume_by_codedeploy.json
# }

# data "aws_iam_policy_document" "codedeploy" {
#   statement {
#     sid    = "AllowLoadBalancingAndECSModifications"
#     effect = "Allow"

#     actions = [
#       "ecs:CreateTaskSet",
#       "ecs:DeleteTaskSet",
#       "ecs:DescribeServices",
#       "ecs:UpdateServicePrimaryTaskSet",
#       "elasticloadbalancing:DescribeListeners",
#       "elasticloadbalancing:DescribeRules",
#       "elasticloadbalancing:DescribeTargetGroups",
#       "elasticloadbalancing:ModifyListener",
#       "elasticloadbalancing:ModifyRule",
#     ]

#     resources = ["*"]
#   }

#   statement {
#     sid    = "AllowS3"
#     effect = "Allow"

#     actions = ["s3:GetObject"]

#     resources = ["${aws_s3_bucket.codepipeline_bucket.arn}/*"]
#   }

#   statement {
#     sid    = "AllowPassRole"
#     effect = "Allow"

#     actions = ["iam:PassRole"]

#     resources = [
#       var.ecs-task-execution-role,
#       var.ecs_role
#     ]
#   }
# }

# resource "aws_iam_role_policy" "codedeploy" {
#   role   = aws_iam_role.codedeploy.name
#   policy = data.aws_iam_policy_document.codedeploy.json
# }