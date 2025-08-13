# Associates AZ1 public subnet (Web) with public route table
### @IDX:ASSOCIATION_PUBLIC_RT_1
resource "aws_route_table_association" "public_web_rt_1" {
  subnet_id      = aws_subnet.pub_web_az_1.id
  route_table_id = aws_route_table.public_web_rt.id
}

# Associates AZ2 public subnet (Web) with public route table
### @IDX:ASSOCIATION_PUBLIC_RT_2
resource "aws_route_table_association" "public_web_rt_2" {
  subnet_id      = aws_subnet.pub_web_az_2.id
  route_table_id = aws_route_table.public_web_rt.id
}

# Associates AZ1 private subnet (App) with private route table
### @IDX:ASSOCIATION_PRIVATE_RT_APP_1
resource "aws_route_table_association" "private_app_rt_1" {
  subnet_id      = aws_subnet.pri_app_az_1.id
  route_table_id = aws_route_table.private_app_rt.id
}

# Associates AZ2 private subnet (App) with private route table
### @IDX:ASSOCIATION_PRIVATE_RT_APP_2
resource "aws_route_table_association" "private_app_rt_2" {
  subnet_id      = aws_subnet.pri_app_az_2.id
  route_table_id = aws_route_table.private_app_rt.id
}

# Associates AZ1 private subnet (Database) with private route table
### @IDX:ASSOCIATION_PRIVATE_RT_DB_1
resource "aws_route_table_association" "private_db_rt_1" {
  subnet_id      = aws_subnet.pri_db_az_1.id
  route_table_id = aws_route_table.private_app_rt.id
}

# Associates AZ2 private subnet (Database) with private route table
### @IDX:ASSOCIATION_PRIVATE_RT_DB_1
resource "aws_route_table_association" "private_db_rt_2" {
  subnet_id      = aws_subnet.pri_db_az_2.id
  route_table_id = aws_route_table.private_app_rt.id
}
