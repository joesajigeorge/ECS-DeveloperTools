resource "aws_vpc" "main" {
    cidr_block       = var.vpc_cidr
    instance_tenancy = "default"

    tags = {
        Name = "${var.projectname}-${var.env}"
    }
}

resource "aws_internet_gateway" "main" {
    depends_on    = [ aws_vpc.main ]
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.projectname}-${var.env}-igw"
    }
}

resource "aws_route_table" "public" {
    depends_on    = [ aws_vpc.main, aws_internet_gateway.main ]
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "${var.projectname}-${var.env}-public"
    }
}

resource "aws_main_route_table_association" "main" {
    depends_on    = [ aws_vpc.main ]
    vpc_id         = aws_vpc.main.id
    route_table_id = aws_route_table.public.id
}

resource "aws_eip" "eip" {
    vpc = true
    tags = {
        Name = "${var.projectname}${var.env}-eip"
    }
}

resource "aws_nat_gateway" "nat" {
    depends_on    = [ aws_vpc.main, aws_subnet.public_subnet ]
    allocation_id = aws_eip.eip.id
    subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
    tags = {
        Name = "${var.projectname}${var.env}-nat"
    }
}

resource "aws_route_table" "private" {
    depends_on    = [ aws_vpc.main, aws_nat_gateway.nat ]
    vpc_id        = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
        Name = "${var.projectname}-${var.env}-private"
    }
}