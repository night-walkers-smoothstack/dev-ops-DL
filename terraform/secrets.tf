data "aws_secretsmanager_secret" "dbkeys" {
  name = var.secret_key_name
}

data "aws_secretsmanager_secret_version" "dbkeys-current" {
  secret_id     = data.aws_secretsmanager_secret.dbkeys.id
  version_stage = "AWSCURRENT"
}