resource "aws_instance" "mongodb" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mongodb_sg_id]
    subnet_id = local.database_subnet_ids

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-mongodb"
        }
    ) 
}

resource "terraform_data" "mongodb" {
    triggers_replace = [
        aws_instance.mongodb.id
    ]

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"      
    }

    connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws_instance.mongodb.private_ip
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh mongodb"
         ]
    }
}

resource "aws_instance" "redis" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.redis_sg_id]
    subnet_id = local.database_subnet_ids

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-redis"
        }
    ) 
}

resource "terraform_data" "redis" {
    triggers_replace = [
        aws_instance.redis.id
    ]

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"      
    }

    connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws_instance.redis.private_ip
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh redis"
         ]
    }
}

resource "aws_instance" "mysql" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mysql_sg_id]
    subnet_id = local.database_subnet_ids
    iam_instance_profile = "EC2RoleToFetchSSMParams" ##Here we are attaching aws role to mysql instance to grep the SSM parameters
    ##Make sure the required SSM parameteres should be created.

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-mysql"
        }
    ) 
}

resource "terraform_data" "mysql" {
    triggers_replace = [
        aws_instance.mongodb.id
    ]

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"      
    }

    connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws_instance.mysql.private_ip
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh mysql"
         ]
    }
}

resource "aws_instance" "rabbitmq" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.rabbitmq_sg_id]
    subnet_id = local.database_subnet_ids

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-rabbitmq"
        }
    ) 
}

resource "terraform_data" "rabbitmq" {
    triggers_replace = [
        aws_instance.rabbitmq.id
    ]

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"      
    }

    connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws_instance.rabbitmq.private_ip
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh rabbitmq"
         ]
    }
}

resource "aws_route53_record" "mongodb" {
    zone_id = var.zone_id
    name = "mongodb-${var.environment}.${var.zone_name}" #mongodb-dev.arunkumarnelluri.site
    type = "A"
    ttl = 1
    records = [aws_instance.mongodb.private_ip]
    allow_overwrite = true
}

resource "aws_route53_record" "redis" {
    zone_id = var.zone_id
    name = "mongodb-${var.environment}.${var.zone_name}" #redis-dev.arunkumarnelluri.site
    type = "A"
    ttl = 1
    records = [aws_instance.redis.private_ip]
    allow_overwrite = true
}

resource "aws_route53_record" "mysql" {
    zone_id = var.zone_id
    name = "mongodb-${var.environment}.${var.zone_name}" #mysql-dev.arunkumarnelluri.site
    type = "A"
    ttl = 1
    records = [aws_instance.mysql.private_ip]
    allow_overwrite = true
}

resource "aws_route53_record" "rabbitmq" {
    zone_id = var.zone_id
    name = "mongodb-${var.environment}.${var.zone_name}" #rabbitmq-dev.arunkumarnelluri.site
    type = "A"
    ttl = 1
    records = [aws_instance.rabbitmq.private_ip]
    allow_overwrite = true
}
