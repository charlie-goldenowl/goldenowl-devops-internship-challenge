resource "aws_ssm_parameter" "image_tag" {
  name  = "/${var.project}/image-tag"
  type  = "String"
  value = var.image_tag

  lifecycle {
    ignore_changes = [value]
  }
}