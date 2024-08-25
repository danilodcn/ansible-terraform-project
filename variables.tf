variable "instances" {
  type = map(object({
    instance_type = string
    instance_ami  = string
    id : string
    os_name : string
    worker_type : optional(string, "node")
    volume_size: optional(number, 10)
  }))

  default = {
    instance_01 : {
      id : 1
      instance_type = "t4g.large"
      instance_ami  = "ami-070f589e4b4a3fece" # Ubuntu 22.04
      os_name : "Ubuntu 22.04"
      worker_type = "master"
      volume_size = 15
    }

    instance_02 : {
      id : 2
      instance_type = "t4g.large"
      instance_ami  = "ami-070f589e4b4a3fece" # Ubuntu 22.04
      os_name : "Ubuntu 22.04"
    }

  }
}
