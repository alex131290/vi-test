resource "aws_ecr_repository" "ecr_repositories" {
  for_each             = var.ecr_repositories_names
  name                 = each.value
  image_tag_mutability = var.image_tag_mutability
  tags                 = local.tags
}


resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  for_each   = var.ecr_repositories_names
  repository = aws_ecr_repository.ecr_repositories[each.value].name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
