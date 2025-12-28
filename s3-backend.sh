aws s3api create-bucket \
  --bucket mahin-terraform-state-bucket \
  --region ap-south-1

aws s3api put-bucket-versioning \
  --bucket mahin-terraform-state-bucket \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket mahin-terraform-state-bucket \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
