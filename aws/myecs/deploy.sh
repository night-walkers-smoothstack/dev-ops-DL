source .env_aws

# aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin ${ECR_REPO} 


aws cloudformation deploy \
    --capabilities CAPABILITY_IAM \
    --template-file cf.yml \
    --stack-name ${STACK_NAME} \
    --parameter-overrides \
                    dbHost=$(aws ssm get-parameter --name database_host | jq -r '.["Parameter"]["Value"]') \
                    vpc=${AWS_VPC} \
                    subnet1=${AWS_SUBNET1} \
                    subnet2=${AWS_SUBNET2} \
                    secretArn=$(aws secretsmanager get-secret-value --secret-id ${SECRET_ID} | jq -r '.["ARN"]') \
                    ecrRepo=${ECR_REPO} \
                    loadBal=${LOAD_BAL}