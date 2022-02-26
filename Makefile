DIR = cd ../
.EXPORT_ALL_VARIABLES:
include .env


build:
	$(DIR)aline-underwriter-microservice-DL; mvn clean install -DskipTests
	$(DIR)aline-bank-microservice-DL; mvn clean install -DskipTests
	$(DIR)aline-transaction-microservice-DL; mvn clean install -DskipTests
	$(DIR)aline-user-microservice-DL; mvn clean install -DskipTests

underwriter:
	export APP_PORT=8083; $(DIR); java -jar aline-underwriter-microservice-DL/underwriter-microservice/target/underwriter-microservice-0.1.0.jar
bank:
	export APP_PORT=8071; $(DIR); java -jar aline-bank-microservice-DL/bank-microservice/target/bank-microservice-0.1.0.jar
transaction:
	export APP_PORT=8073; $(DIR); java -jar aline-transaction-microservice-DL/transaction-microservice/target/transaction-microservice-0.1.0.jar
user:
	export APP_PORT=8070; $(DIR); java -jar aline-user-microservice-DL/user-microservice/target/user-microservice-0.1.0.jar