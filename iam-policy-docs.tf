data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["monitoring.rds.amazonaws.com", "rds.amazonaws.com"]
      type        = "Service"
    }
  }
}
