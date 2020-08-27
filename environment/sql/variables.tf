variable "name" {
  type = string
  description = "Nazwa instancji"
}

variable "database_version" {
  type = string
  description = "Wersja bazy danych -> MYSQL_5_6, POSTGRES_12, SQLSERVER_2017_STANDARD..."
}

variable "region" {
  type = string
  description = "Region w którym chcemy utworzyc instancje bazy, powinien to byc region projektu"
}

