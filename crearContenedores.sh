sudo docker build -t ldap-img -f ./Dockerfile.LDAP .
sudo docker run -d --network my-network --name ldap-container -p 636:636 -p 389:389 -e LDAP_ADMIN_PASSWORD="admin" ldap-img
sudo docker build -t img-apache -f ./Dockerfile.web .
sudo docker run -d --network my-network --name apache-container -p 443:443 -p 80:80 img-apache