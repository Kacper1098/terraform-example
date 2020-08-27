variable "name" {
  type = string
  description = "Nazwa clustra"
}

variable "location" {
  type = string
  description = "Region lub zone naszego clustra. Powinien to być ten sam region w którym znajduje się nasz projekt"
}
