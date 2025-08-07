variable "mysql_config" {
  type    = tuple([string, number, bool])
  default = ["db.t4g.micro", 3, false]
}
