resource "aws_subnet" "public_subnet" {
    depends_on    = [ aws_vpc.main ]
    count                   = length(var.public_subnet)
    vpc_id                  = aws_vpc.main.id
    cidr_block              = lookup(var.public_subnet[count.index], "cidr")
    map_public_ip_on_launch = "true"
    availability_zone       = lookup(var.public_subnet[count.index], "availability_zone")
    tags = {
        Name = "${var.projectname}-${var.env}-public"
        Tier = "Public"
    }
}

resource "aws_route_table_association" "public-subnet-route_table-association" {
    depends_on    = [ aws_vpc.main ]
    count                   = length(var.public_subnet)
    subnet_id               = aws_subnet.public_subnet[count.index].id
    route_table_id          = aws_route_table.public.id
}