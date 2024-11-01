
terraform {
    required_providers {
        mgc = {
            source = "magalucloud/mgc"
        }
    }
}

provider "mgc" {
    alias = "nordeste"
    region = "br-ne1"
    api_key = "123"
    object_storage = {
        key_pair = {
            key_id = "123"
            key_secret = "123"
        }
    }
}

resource "mgc_virtual_machine_instances" "123" {
    provider = mgc.nordeste
    name = "123"

    machine_type = {
        name = "BV1-1-10"
    }

    image = {
        name = "cloud-ubuntu-22.04 LTS"
    }

    network = {
        associate_public_ip = true
        delete_public_ip = true
    }

    ssh_key_name = "123"

    provisioner "remote-exec" {
        inline = [
            "sudo apt remove -y needrestart",
            "sudo apt-get update",
            "sudo apt-get upgrade -y",
            "sudo apt install default-jre -y",
        ]
    }

    connection {
        type = "ssh"
        user = "ubuntu"
        agent = true
        host = self.network.public_address
    }
}
