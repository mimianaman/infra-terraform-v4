# Output the MSK cluster bootstrap brokers for plaintext connections
output "msk_bootstrap_brokers_plaintext" {
  value       = aws_msk_cluster.kafka.bootstrap_brokers
  description = "MSK cluster bootstrap brokers for plaintext connection"
}

# Output the MSK cluster bootstrap brokers for TLS connections
output "msk_bootstrap_brokers_tls" {
  value       = aws_msk_cluster.kafka.bootstrap_brokers_tls
  description = "MSK cluster bootstrap brokers for TLS connection"
}

# Output the MSK cluster bootstrap brokers for SASL SCRAM authentication
output "msk_bootstrap_brokers_sasl_scram" {
  value       = aws_msk_cluster.kafka.bootstrap_brokers_sasl_scram
  description = "MSK cluster bootstrap brokers for SASL SCRAM authentication"
}

# Output Elasticache Cluster Endpoint
output "redis_endpoints" {
  value = [
    for node in aws_elasticache_cluster.redis.cache_nodes : {
      address = node.address
      port    = node.port
    }
  ]
  description = "List of Redis node endpoints and their ports"
}