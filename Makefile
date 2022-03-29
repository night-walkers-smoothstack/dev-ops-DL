DIR = ./backend/
SERVICES = user bank transaction underwriter
NPROCS = $(shell sysctl -n hw.logicalcpu) # get number of logical cores
MAKEFLAGS += -j$(NPROCS) # set multithreading to num of logical cores
REPO = 'public.ecr.aws\/l4g0u1s9'
AWS_REGION = 'us-east-1'
.EXPORT_ALL_VARIABLES:
include .env

# build jar files
build: build-underwriter build-bank build-transaction build-user build-gateway
.PHONY: build

build-underwriter:
	cd $(DIR)underwriter; mvn clean package -DskipTests
build-bank:
	cd $(DIR)bank; mvn clean package -DskipTests 
build-transaction:
	cd $(DIR)transaction; mvn clean package -DskipTests
build-user:
	cd $(DIR)user; mvn clean package -DskipTests

build-gateway:
	cd $(DIR)gateway; mvn clean package -DskipTests

# docker compose
up: 
	docker-compose up
down:
	docker-compose down

# run locally
underwriter:
	export APP_PORT=$(PORT_UNDERWRITER_MS); cd $(DIR); java -jar aline-underwriter-microservice-DL/underwriter-microservice/target/underwriter-microservice-0.1.0.jar
bank:
	export APP_PORT=$(PORT_BANK_MS); cd $(DIR); java -jar aline-bank-microservice-DL/bank-microservice/target/bank-microservice-0.1.0.jar
transaction:
	export APP_PORT=$(PORT_TRANSACTION_MS); cd $(DIR); java -jar aline-transaction-microservice-DL/transaction-microservice/target/transaction-microservice-0.1.0.jar
user:
	export APP_PORT=$(PORT_USER_MS); cd $(DIR); java -jar aline-user-microservice-DL/user-microservice/target/user-microservice-0.1.0.jar


dockerize: dockerize-underwriter dockerize-bank dockerize-transaction dockerize-user dockerize-gateway
.PHONY: dockerize

dockerize-underwriter:
	docker build ${DIR}underwriter -t aline-underwriter
dockerize-bank:
	docker build ${DIR}bank -t aline-bank
dockerize-transaction:
	docker build ${DIR}transaction -t aline-transaction
dockerize-user:
	docker build ${DIR}user -t aline-user
dockerize-gateway:
	docker build ${DIR}gateway -t aline-gateway

# to use, say make checkout b=<branch-name>
checkout:
	cd ${DIR}underwriter; git checkout -b ${b}
	cd ${DIR}bank; git checkout -b ${b}
	cd ${DIR}transaction; git checkout -b ${b}
	cd ${DIR}user; git checkout -b ${b}


.PHONY: dockerfile
dockerfile:
	sh automations/updocker.sh 'underwriter-microservice' backend/underwriter
	sh automations/updocker.sh 'bank-microservice' backend/bank
	sh automations/updocker.sh 'transaction-microservice' backend/transaction
	sh automations/updocker.sh 'user-microservice' backend/user

.PHONY: jenkinsfile
jenkinsfile:
	sh automations/upjenkins.sh 'aline-underwriter' '0.1.0' ${REPO} ${AWS_REGION} backend/underwriter/
	sh automations/upjenkins.sh 'aline-bank' '0.1.0' ${REPO} ${AWS_REGION} backend/bank/
	sh automations/upjenkins.sh 'aline-transaction' '0.1.0' ${REPO} ${AWS_REGION} backend/transaction/
	sh automations/upjenkins.sh 'aline-user' '0.1.0' ${REPO} ${AWS_REGION} backend/user/

runfile:
	cp templates/run.sh  backend/underwriter/
	cp templates/run.sh  backend/bank/
	cp templates/run.sh  backend/transaction/
	cp templates/run.sh  backend/user/