variable "vcenter_host" {
    default = ""
}


variable "vcenter_username" {
    default = ""
}


variable "vcenter_password" {
    default = ""
}

variable "vm_template" {
    default = ""
}

variable "private_key" {
  description = "path of private key for RKE nodes"
  default     = "/home/mohamed/.ssh/MacOSsKey.pem"
}

variable "rancher_version" {
  description = "Version of Rancher Server"
  default     = "2.4.8"
}


variable "vm_count" {
  description = "Number of VMs to spin up for RKE"
  default = 3
}


