
expected arguments:
* file_to_upload - which file to upload
* s3_path - path at destenation

optional arguments:
* aws_cli_installation_required - If aws cli installation required. values: 1 (yes), 0 (no) - default=0

Required Enviroment Varaibles:
AWS_ACCESS_KEY AWS_SECRET REGION BUCKET

run the file:
```
./upload_to_s3.sh /tmp/file_to_upload.txt my/path/in_s3 0
```

