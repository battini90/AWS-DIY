provider aws {
  access_key = ${var.access_key}
  secret_key = ${var.secret_key}
  region     = ${var.region}
}

# resource aws_instance app_server {
#   ami           = ami-2757f631
#   instance_type = t2.micro
# }