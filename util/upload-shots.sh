#!/usr/bin/env bash
# Script to upload screenshots to S3
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

AWS_DEFAULT_REGION=us-west-2
S3_BUCKET="s3://joshbeard.me-photos"
S3_PATH="screenshots"
SRC_PATH="$SCRIPT_PATH/../src/screenshots"

if ! [ -x "$(command -v aws)" ]; then
  echo "Error: aws-cli is not installed." >&2
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "Error: AWS_ACCESS_KEY_ID is not set." >&2
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "Error: AWS_SECRET_ACCESS_KEY is not set." >&2
  exit 1
fi

if ! aws s3 ls $S3_BUCKET 2>&1 | grep -q 'NoSuchBucket'; then
  echo "Error: S3 bucket does not exist." >&2
  exit 1
fi


aws s3 sync $SRC_PATH $S3_BUCKET/$S3_PATH --acl public-read --delete
