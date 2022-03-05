DIR = cd ./
NPROCS = $(shell sysctl hw.ncpu  | grep -o '[0-9]\+')
MAKEFLAGS += -j$(NPROCS)
.EXPORT_ALL_VARIABLES:
include .env


build: build-underwriter build-bank build-transaction build-user
.PHONY: build

build-underwriter:
	$(DIR)aline-underwriter-microservice-DL; mvn clean install -DskipTests
build-bank:
	$(DIR)aline-bank-microservice-DL; mvn clean install -DskipTests 
	# mvn package
build-transaction:
	$(DIR)aline-transaction-microservice-DL; mvn clean install -DskipTests
build-user:
	$(DIR)aline-user-microservice-DL; mvn clean install -DskipTests

build-gateway:
	$(DIR)aline-user-microservice-DL; mvn clean install -DskipTests


underwriter:
	export APP_PORT=$(PORT_UNDERWRITER_MS); $(DIR); java -jar aline-underwriter-microservice-DL/underwriter-microservice/target/underwriter-microservice-0.1.0.jar
bank:
	export APP_PORT=$(PORT_BANK_MS); $(DIR); java -jar aline-bank-microservice-DL/bank-microservice/target/bank-microservice-0.1.0.jar
transaction:
	export APP_PORT=$(PORT_TRANSACTION_MS); $(DIR); java -jar aline-transaction-microservice-DL/transaction-microservice/target/transaction-microservice-0.1.0.jar
user:
	export APP_PORT=$(PORT_USER_MS); $(DIR); java -jar aline-user-microservice-DL/user-microservice/target/user-microservice-0.1.0.jar