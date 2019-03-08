# route53-backup
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/habitissimo/route53-backup.svg)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/habitissimo/route53-backup.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/habitissimo/route53-backup.svg)
![Docker Stars](https://img.shields.io/docker/stars/habitissimo/route53-backup.svg)

A tool that makes backups of AWS Route53 records and stores them to S3 bucket

* [barnybug/cli53](https://github.com/barnybug/cli53)
* [aws/aws-cli](https://github.com/aws/aws-cli)

## Running route53-backup

### Running by setting AWS credentials through environment variables

```bash
docker run --rm \
  -e AWS_ACCESS_KEY_ID=<your-access-key-id> \
  -e AWS_SECRET_ACCESS_KEY=<your-secret-access-key> \
  -e AWS_S3_BUCKET=<your-bucket-name> \
  habitissimo/route53-backup
```

### Running by setting AWS credentials through credentials file
Create a file containing your credentials:

```ini
[default]
aws_access_key_id=<your-access-key-id>
aws_secret_access_key=<your-secret-access-key>
```

``` bash
docker run --rm \
  -v $(pwd)/credentials:/root/.aws/config
  -e AWS_CONFIG_FILE=/root/.aws/config \
  -e AWS_S3_BUCKET=<your-bucket-name> \
  habitissimo/route53-backup
```

## AWS IAM permissions
The IAM user must have the following policies attached.

### Route 53
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "route53:GetHostedZone",
                "route53:ListResourceRecordSets"
            ],
            "Resource": "arn:aws:route53:::hostedzone/*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:GetHostedZoneCount",
                "route53:ListHostedZonesByName"
            ],
            "Resource": "*"
        }
    ]
}
```

### S3
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
            ],
            "Resource": "arn:aws:s3:::my-bucket-name/*"
        }
    ]
}
```