export SECRET=$(ls secrets/*.json | head -1)

if [ -z SECRET ]
then
    echo 'secrets.json missing'
else
    STACK=$(aws cloudformation list-stacks --profile night | grep mynewalineresourcesdl)
    test $STACK || aws cloudformation deploy --template-data cfn/resources.yml --stack-name mynewalineresourcesdl --profile night

    AWS_SECRET_OBJ=$(aws cloudformation describe-stacks --stack-name mynewalineresourcesdl  --profile night --query 'Stacks[0].Outputs[?OutputKey==`key`].OutputValue' --output text | cat)
    export AWS_SECRET_OBJ

    EKS_VPC=$(aws cloudformation describe-stacks --stack-name mynewalineresourcesdl  --profile night --query 'Stacks[0].Outputs[?OutputKey==`vpc`].OutputValue' --output text | cat)
    test EKS_VPC && export EKS_VPC || echo "Cloudformation VPC not set"

    EKS_PRIVATE_SUBNET=$(aws cloudformation describe-stacks --stack-name mynewalineresourcesdl  --profile night --query 'Stacks[0].Outputs[?OutputKey==`private1`].OutputValue' --output text | cat)
    test EKS_PRIVATE_SUBNET && export EKS_PRIVATE_SUBNET || echo "Cloudformation private subnet not set"

    EKS_PRIVATE_SUBNET_AZ=$(aws ec2 describe-subnets --subnet-ids $EKS_PRIVATE_SUBNET --profile night --query 'Subnets[0].AvailabilityZone' | cat)
    test EKS_PRIVATE_SUBNET_AZ && export EKS_PRIVATE_SUBNET_AZ || echo "Cloudformation private subnet availability zone not set"

    EKS_PRIVATE_TWO_SUBNET=$(aws cloudformation describe-stacks --stack-name mynewalineresourcesdl  --profile night --query 'Stacks[0].Outputs[?OutputKey==`public1`].OutputValue' --output text | cat)
    test EKS_PRIVATE_TWO_SUBNET && export EKS_PRIVATE_TWO_SUBNET || echo "Cloudformation private subnet not set"

    EKS_PRIVATE_TWO_SUBNET_AZ=$(aws ec2 describe-subnets --subnet-ids $EKS_PRIVATE_TWO_SUBNET --profile night --query 'Subnets[0].AvailabilityZone' | cat)
    test EKS_PRIVATE_TWO_SUBNET_AZ && export EKS_PRIVATE_TWO_SUBNET_AZ || echo "Cloudformation private subnet availability zone not set"

    AWS_SECRET_OBJ=$(aws cloudformation describe-stacks --stack-name mynewalineresourcesdl  --profile night --query 'Stacks[0].Outputs[?OutputKey==`key`].OutputValue' --output text | cat)
    test AWS_SECRET_OBJ && export AWS_SECRET_OBJ || echo "Cloudformation VPC not set"

    # apply to file
    cat eksctl_config_template.yml | envsubst > eksctl_config.yml
fi

