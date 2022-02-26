DIR = cd ../
.EXPORT_ALL_VARIABLES:
	include .env

run:
	$(DIR); java -jar aline-underwriter-microservice-DL/underwriter-microservice/target/underwriter-microservice-0.1.0.jar

	$(DIR); java -jar aline-bank-microservice-DL/bank-microservice/target/bank-microservice-0.1.0.jar

	$(DIR); java -jar aline-transaction-microservice-DL/transaction-microservice/target/transaction-microservice-0.1.0.jar

	$(DIR); java -jar aline-user-microservice-DL/user-microservice/target/user-microservice-0.1.0.jar

build:
	$(DIR)aline-underwriter-microservice-DL; mvn clean install -DskipTests
	$(DIR)aline-bank-microservice-DL; mvn clean install -DskipTests
	$(DIR)aline-transaction-microservice-DL; mvn clean install -DskipTests
	$(DIR)aline-user-microservice-DL; mvn clean install -DskipTests
