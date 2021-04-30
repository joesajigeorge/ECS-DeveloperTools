resource "aws_subnet" "private_subnet" {
    depends_on    = [ aws_vpc.main ]
    count                   = length(var.private_subnet)
    vpc_id                  = aws_vpc.main.id
    cidr_block              = lookup(var.private_subnet[count.index], "cidr")
    availability_zone       = lookup(var.private_subnet[count.index], "availability_zone")
    tags = {
        Name = "${var.projectname}-${var.env}-private"
        Tier = "Private"
    }
}

resource "aws_route_table_association" "private-subnet-route_table-association" {
    depends_on    = [ aws_vpc.main ]
    count                   = length(var.private_subnet)
    subnet_id               = aws_subnet.private_subnet[count.index].id
    route_table_id          = aws_route_table.private.id
}