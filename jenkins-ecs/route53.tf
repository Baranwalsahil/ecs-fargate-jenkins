resource "aws_route53_zone" "hosted_zone" {
  name = "fargate.com"  
}

resource "aws_route53_record" "cname_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "ecs-jenkins.fargate.com" 
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.alb.dns_name]  
}