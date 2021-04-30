# data "aws_subnet_ids" "private" {
#   vpc_id = var.vpc_id

#   tags = {
#     Tier = "Private"
#   }
# }

# data "aws_subnet" "private_subnet" {
#   count = "${length(data.aws_subnet_ids.private.ids)}"
#   id    = "${tolist(data.aws_subnet_ids.private.ids)[count.index]}"
# }

# data "aws_subnet_ids" "public" {
#   vpc_id = var.vpc_id

#   tags = {
#     Tier = "Public"
#   }
# }

# data "aws_subnet" "public_subnet" {
#   count = "${length(data.aws_subnet_ids.public.ids)}"
#   id    = "${tolist(data.aws_subnet_ids.public.ids)[count.index]}"
# }