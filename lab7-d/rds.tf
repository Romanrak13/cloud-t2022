
resource "aws_db_instance" "Lab7" {
    identifier = "mysqldb"
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    db_name = "dbtest"
    username = "testuser"
    password = user.password
    storage_type = "gp2"
    allocated_storage = 20
    parameter_group_name = "default.mysql5.7"
    port = "3306"
    vpc_security_group_ids = [aws_security_group.lab7_sg.id]
    db_subnet_group_name = aws_db_subnet_group.db_sg.id
    skip_final_snapshot = true
    publicly_accessible = true
    
    tags = {
      Name = "Lab 7 MySQL RDS Instance"
    }
}
