output "domain_validation" {
    value = aws_acm_certificate.cert.domain_validation_options
}
output "cert_arn" {
    value = aws_acm_certificate.cert.arn
}