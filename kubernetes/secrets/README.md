This directory stores secrets for the kubernetes deployment. Please create a file named dbsecrets.yml and paste in the following template:

```
apiVersion: v1
kind: Secret
metadata:
  name: dbsecrets
type: Opaque
stringData:
  db_username: 
  db_password: 
  MYSQL_ROOT_PASSWORD: 
  MYSQL_DATABASE: 
  encrypt_secret_key: 
  app_user_access_key: 
```