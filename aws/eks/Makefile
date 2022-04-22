val=$(aws cloudformation describe-stacks --stack-name alinefinancialdl  --profile night --query 'Stacks[0].Outputs[?OutputKey==`vpc`].OutputValue' --output text)


default:
	@echo "requires build argument"

stack:
	aws cloudformation create-stack --template-body file:///Users/dylan-work/code/smoothstack/capstone/dev-ops-DL/aws/eks/cfn/vpc.yml --stack-name alinefinancialdl --profile night


stackinfo: $(eval SHELL:=/bin/bash)
	@printf 'VPC: '
	@aws cloudformation describe-stacks --stack-name alinefinancialdl  --profile night --query 'Stacks[0].Outputs[?OutputKey==`vpc`].OutputValue' --output text | cat
	@printf 'Peering: '
	@aws cloudformation describe-stacks --stack-name alinefinancialdl  --profile night --query 'Stacks[0].Outputs[?OutputKey==`peering`].OutputValue' --output text | cat
	@printf 'Private Subnet: '
	@aws cloudformation describe-stacks --stack-name alinefinancialdl  --profile night --query 'Stacks[0].Outputs[?OutputKey==`private1`].OutputValue' --output text | cat

delete-stack:
	aws cloudformation delete-stack --stack-name alinefinancialdl  --profile night

pit:
	echo "i like pie"


# aws cloudformation deploy --template-file cfn/vpc.yml --stack-name alinefinancialdl --profile night