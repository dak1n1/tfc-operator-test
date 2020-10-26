# These variables are used to test populating terraform
# variables into TFC from the Workspace CR.

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "size" {
  type = number
}
