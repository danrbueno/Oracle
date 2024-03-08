For this repository, I'm using Oracle database under a Docker container.

Open a terminal prompt and input the commands below to create an Oracle database under Docker container:

1. Log into Docker Hub:
<br><code>docker login</code>

2. Get latest Oracle image for Docker:
<br><code>docker pull container-registry.oracle.com/database/express:latest</code>

3. Create a new container:
<br><code>docker container create -it --name [YOUR CONTAINER NAME] -p 1521:1521 -e ORACLE_PWD=[YOUR DATABASE PASSWORD] container-registry.oracle.com/database/express:latest</code>

4. Start container:
<br><code>docker start [YOUR CONTAINER NAME]</code>

5. Open container:
<br><code>docker exec -it [YOUR CONTAINER NAME] bash</code>

6. Connect to sqlplus inside the container:
<br><code>sqlplus sys as sysdba</code>
