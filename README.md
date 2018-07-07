# Usage


## ATTENTION!!
Host machine must open the **port 80** for the web server and the **port 2222** for git server, first!
## STEP
1. on host, upload docker-compose.yaml to the host then 
```
$ docker-compose up -d
```
2. on client, generate the key and copy to the host
```
$ ssh-keygen -t rsa
$ scp ~/.ssh/id_rsa.pub root@<HOST_IP>:~/hexo-server/keys
```
3. on host,restart the container for accept the keys
```
$ docker-compose restart
```
4. on client clone the 
```
$ git clone ssh://git@<HOST_IP>:2222/hexo-server/repos/hexo.git
```
5. now enjoy hexo
browser http://<HOST_IP>
