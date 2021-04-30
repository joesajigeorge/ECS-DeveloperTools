resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = var.pipeline_artifact_bucket_name
  acl    = "private"
}