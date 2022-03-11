DIR = cd ./backend/
NPROCS = $(shell sysctl -n hw.logicalcpu) # get number of logical cores
MAKEFLAGS += -j$(NPROCS) # set multithreading to num of logical cores
.EXPORT_ALL_VARIABLES:
include .env

# build jar files
build: build-underwriter build-bank build-transaction build-user build-gateway
.PHONY: build

build-underwriter:
	$(DIR)underwriter; mvn clean package -DskipTests
build-bank:
	$(DIR)bank; mvn clean package -DskipTests 
	# mvn package
build-transaction:
	$(DIR)transaction; mvn clean package -DskipTests
build-user:
	$(DIR)user; mvn clean package -DskipTests

build-gateway:
	$(DIR)gateway; mvn clean package -DskipTests

# docker compose
up: 
	docker-compose up
down:
	docker-compose down

# run locally
underwriter:
	export APP_PORT=$(PORT_UNDERWRITER_MS); $(DIR); java -jar aline-underwriter-microservice-DL/underwriter-microservice/target/underwriter-microservice-0.1.0.jar
bank:
	export APP_PORT=$(PORT_BANK_MS); $(DIR); java -jar aline-bank-microservice-DL/bank-microservice/target/bank-microservice-0.1.0.jar
transaction:
	export APP_PORT=$(PORT_TRANSACTION_MS); $(DIR); java -jar aline-transaction-microservice-DL/transaction-microservice/target/transaction-microservice-0.1.0.jar
user:
	export APP_PORT=$(PORT_USER_MS); $(DIR); java -jar aline-user-microservice-DL/user-microservice/target/user-microservice-0.1.0.jar

