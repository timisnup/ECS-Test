#SSL certficate
data "aws_acm_certificate" "test-cert"{
    domain = "test.wowcher.co.uk"
}
