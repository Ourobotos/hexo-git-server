# Usage

```powershell
# on host
cd hexo-server-docker
docker-compose up -d
# on client
ssh-keygen -t rsa
scp ~/.ssh/id_rsa.pub root@<HOST_IP>:~/hexo-server/keys
# on host
docker-compose restart
# on client
git clone ssh://git@<HOST_IP>:2222/hexo-server/repos/hexo.git
# now enjoy hexo
```
