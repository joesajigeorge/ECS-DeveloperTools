resource "aws_codepipeline" "default" {
  depends_on = [ 
    aws_iam_role.default, 
    aws_iam_role_policy_attachment.default,
    aws_codebuild_project.main,
    aws_s3_bucket.codepipeline_bucket
    ]
  name     = "${var.projectname}-${var.env}-pipeline"
  role_arn = aws_iam_role.default.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.code_start_connection_arn
        FullRepositoryId = var.repo_id
        BranchName       = var.repo_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.main.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName = var.aws_ecs_cluster_name
        ServiceName = var.aws_ecs_service_name
      }

    }
  }
}