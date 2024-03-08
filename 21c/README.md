Open a terminal prompt and write the commands below to create a Oracle database using Docker container:

1. Log into Docker Hub:
<br><code>docker login</code>

3. Get latest Oracle image for Docker:
<br><code>docker pull container-registry.oracle.com/database/express:latest</code>

4. Create a new container:
<br><code>docker container create -it --name oracle-portfolio -p 1521:1521 -e ORACLE_PWD=oracle-portfolio container-registry.oracle.com/database/express:latest</code>

5. Start container:
<br><code>docker start oracle-portfolio</code>

6. Open container:
<br><code>docker exec -it oracle-portfolio bash</code>

7. Connect to sqlplus inside the container:
<br><code>sqlplus sys as sysdba</code>
