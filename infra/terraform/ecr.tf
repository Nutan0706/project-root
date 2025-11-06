resource "aws_ecr_repository" "app" {
  name                 = "${var.project_name}-repo"
  image_tag_mutability = "IMMUTABLE"
}

# output full repo URI
output "ecr_repo_uri" {
  value = aws_ecr_repository.app.repository_url
}
