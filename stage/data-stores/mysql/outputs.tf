output "address" {
  value       = module.mysql.address
  description = "Connect to database endpoint"
}

output "port" {
  value       = module.mysql.port
  description = "Connect to database endpoint"
}
