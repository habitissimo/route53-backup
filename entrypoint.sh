#!/bin/sh
BACKUP_FOLDER=/tmp/route53

# Ensure backup folder exists
mkdir -p $BACKUP_FOLDER

backup_file=

get_zones() {
  cli53 list -f json | jq -r '. | keys[] as $k | "\(.[$k] | .Name)"'
}

make_backup() {
  for zone in `get_zones`;
  do
    # Zone ends with a . (so extension dot is not required here)
    cli53 export $zone --output $BACKUP_FOLDER/${zone}txt;
  done

  local tar_name=backup-`date +%F-%H-%M-%S`.tar.gz
  cd $BACKUP_FOLDER && tar -zcvf $tar_name *.txt &> /dev/null && cd - &> /dev/null
  backup_file=$BACKUP_FOLDER/$tar_name
}

upload_backup() {
  local remote_path=`date +%Y`/`date +%m`/`basename $1`
  aws s3 cp $1 s3://$AWS_S3_BUCKET/$remote_path
  aws s3 cp $1 s3://$AWS_S3_BUCKET/latest.tar.gz
}

cleanup_files() {
  rm -fr $BACKUP_FOLDER
}

make_backup
upload_backup $backup_file
cleanup_files
