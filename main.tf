
terraform {
    required_providers {
        mgc = {
            source = "magalucloud/mgc"
        }
    }
}

provider "mgc" {
    alias = "sudeste"
    region = "br-se1"
    api_key = "123"
    object_storage = {
        key_pair = {
            key_id = "123"
            key_secret = "123"
        }
    }
}

resource "mgc_virtual_machine_instances" "ijiojio" {
    provider = mgc.sudeste
    name = "ijiojio"

    machine_type = {
        name = "BV2-4-40"
    }

    image = {
        name = "cloud-ubuntu-22.04 LTS"
    }

    network = {
        associate_public_ip = true
        delete_public_ip = true
        interface = {
            security_groups = [{
                id = "f215a776-6c46-4857-b111-e41cb4861f3d"
            }]
        }
    }

    ssh_key_name = "45335"

    provisioner "remote-exec" {
        inline = [
            "sudo apt remove -y needrestart",
            "sudo apt-get update",
            "sudo apt-get upgrade -y",
            "wget https://download.oracle.com/java/22/archive/jdk-22.0.2_linux-x64_bin.deb",
            "sudo apt install iputils-ping net-tools mailutils coreutils dnsutils sendmail screen grep nano wget less cron man sed pv -y",
            "sudo dpkg -i jdk-22.0.2_linux-x64_bin",
            "wget -O setup.sh https://raw.githubusercontent.com/simylein/minecraft-server/main/setup.sh && chmod +x setup.sh",
            "./setup.sh --name minecraft --proceed true --version 1.21 --port 25565 --eula true --remove true --start true"
        ]
    }

    connection {
        type        = "ssh"
        user        = "debian"
        agent       = true
        host        = self.network.public_address
    }
}
