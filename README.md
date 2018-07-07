# Usage

```powershell
# ATTENTION!!
# Host machine must open the port 80 for the web server and the port 2222 for git server, first!
# on host, go into the dir of docker-compose.yaml then 
$ docker-compose up -d
# on client, generate the key and copy to the host
$ ssh-keygen -t rsa
$ scp ~/.ssh/id_rsa.pub root@<HOST_IP>:~/hexo-server/keys
# on host,restart the container for accept the keys
$ docker-compose restart
# on client clone the 
$ git clone ssh://git@<HOST_IP>:2222/hexo-server/repos/hexo.git
# now enjoy hexo
# http://<HOST_IP>

```
