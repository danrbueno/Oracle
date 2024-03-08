Open a terminal prompt and write the commands below to create a Oracle database using Docker container:

1. Log into Docker Hub:
docker login

2. Get latest Oracle image for Docker:
docker pull container-registry.oracle.com/database/express:latest

3. Create a new container:
docker container create -it --name oracle-portfolio -p 1521:1521 -e ORACLE_PWD=oracle-portfolio container-registry.oracle.com/database/express:latest

4. Start container:
docker start oracle-portfolio

5. Open container:
docker exec -it oracle-portfolio bash

6. Connect to sqlplus inside the container:
sqlplus sys as sysdba
