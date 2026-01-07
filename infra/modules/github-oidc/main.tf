data "aws_caller_identity" "current" {}

# GitHub OIDC provider (safe to create once per account)
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  # GitHub's OIDC root CA thumbprint (commonly used)
  # If your org already has this provider, import instead of creating.
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
  lifecycle {
    prevent_destroy = true
  }
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Allow:
    # - pushes to main (deploy)
    # - pull_request (plan)
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.repo}:ref:refs/heads/${var.branch}",
        "repo:${var.repo}:pull_request"
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  lifecycle {
    prevent_destroy = true
  }
}

# Minimal state backend access (required for Terragrunt remote_state)
data "aws_iam_policy_document" "state_access" {
  statement {
    sid     = "StateBucketAccess"
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.state_bucket_name}"
    ]
  }

  statement {
    sid     = "StateObjectsAccess"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = [
      "arn:aws:s3:::${var.state_bucket_name}/*"
    ]
  }

  statement {
    sid    = "DynamoLockAccess"
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/${var.lock_table_name}"
    ]
  }

  statement {
    sid       = "CallerIdentity"
    effect    = "Allow"
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "state_access" {
  name   = "${var.role_name}-state-access"
  policy = data.aws_iam_policy_document.state_access.json
}

resource "aws_iam_role_policy_attachment" "state_access" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.state_access.arn
}

# Practical infra permissions (broad-ish but not admin).
# You can tighten later by iterating from CloudTrail/AccessDenied.
data "aws_iam_policy_document" "infra" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "ecs:*",
      "ecr:*",
      "acm:*",
      "route53:*",
      "logs:*",
      "cloudwatch:*",
      "iam:PassRole",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "infra" {
  name   = "${var.role_name}-infra"
  policy = data.aws_iam_policy_document.infra.json
}

resource "aws_iam_role_policy_attachment" "infra" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.infra.arn
}
