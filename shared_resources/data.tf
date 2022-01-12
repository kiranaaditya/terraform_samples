# Get my external IP and store it as a data
data "external" "whatsmyip" {
  program = ["/bin/bash", "${path.module}/whatsmyip.sh"]
}