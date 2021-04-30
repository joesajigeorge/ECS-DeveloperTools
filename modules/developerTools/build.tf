resource "aws_codebuild_project" "main" {
    depends_on = [
        aws_iam_role.build, 
        aws_iam_role_policy_attachment.build
    ]
    name          = "${var.projectname}-${var.env}-build-project"
    description   = "${var.projectname} project ${var.env} environment build project"
    build_timeout = "5"
    service_role  = aws_iam_role.build.arn

    artifacts {
        type = "CODEPIPELINE"
    }

    cache {
        type  = "NO_CACHE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/standard:4.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"
        privileged_mode             = "true"
    }

    logs_config {
        cloudwatch_logs {
        group_name  = "${var.projectname}-${var.env}-build-stream"
        stream_name = "log-stream"
        }
    }

    source {
        type      = "CODEPIPELINE"
        buildspec = "buildspec.yml"
    }

    source_version = var.repo_branch

    tags = {
        Environment = var.env
    }
}