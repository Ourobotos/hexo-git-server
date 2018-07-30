《[在VPS上假设HEXO博客](../../../../2018/03/09/在VPS上架设HEXO博客/)》步骤太繁琐，做了一个ourob/hexo-git-server镜像，并搭配官方nginx镜像，用docker-compose方式实现docker服务器快速部署。

<!-- more -->

# 环境

> 服务器操作系统为 Centos7.4，开启SELinux、Firewalld，配置SSH禁止密码/root用户登录并修改了默认22端口（参见：《[VPS基本安全配置（Centos7）](../../../../2018/03/05/VPS基本安全配置（Centos7）)》），已安装docker和docker-compose（见：《[Centos7安装docker和docker-compose](../../../../2018/07/06/Centos7安装docker和docker-compose/)》）

# 懒人目录
- 服务器
  - 下载并运行docker-compose.yml
  - 开放专用端口
  - 上传公钥，重启容器
- 客户端
  - 修改HEXO配置文件

# 第一步，下载脚本，运行容器
下载docker-compose.yml脚本
```powershell
$ sudo curl -L https://raw.githubusercontent.com/Ourobotos/hexo-git-server/master/docker-compose.yml -o docker-compose.yml
```
运行脚本，开启容器
```powershell
$ sudo docker-compose up -d
...
Creating hexo-git   ... done
Creating hexo-nginx ... done
```
查看docker容器运行情况
```powershell
$ sudo docker ps 
CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                                      NAMES
64836eee0fd0        ourob/hexo-git-server   "ash start.sh"           3 minutes ago       Up 3 minutes        0.0.0.0:2222->22/tcp                       hexo-git
af030d4dab04        nginx                   "nginx -g 'daemon of…"   3 minutes ago       Up 3 minutes        0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   hexo-nginx
```

# 第二步，添加开放端口（脚本默认使用2222）
```powershell
# ===SELinux添加2222端口===
$ sudo semanage port -a -t ssh_port_t -p tcp 2222
# ===查看SELinux生效结果===
$ sudo semanage port -l | grep ssh
# ===防火墙添加2222端口至ssh服务组===
$ sudo firewall-cmd --service=ssh --add-port=2222/tcp --permanent
# ===重载防火墙配置===
$ sudo firewall-cmd --reload
# ===查看防火墙生效结果===
$ sudo firewall-cmd --info-service=ssh

```
# 第三步，上传公钥，重启容器
生成一对新的密钥（见《[VPS基本安全配置（Centos7）](../../../../2018/03/05/VPS基本安全配置（Centos7）)》的**设置免密登录**一节）
```powershell
$ ssh-keygen -t rsa -f hexo.docker.key
```
将公钥hexo.docker.key.pub上传到服务器的/hexo-server/keys/文件夹
(因root权限问题，scp命令无法直接上传至/hexo-server/keys/，因此下面绕一下)
```powershell
# ===本地上传至用户文件夹===
$ scp ~/.ssh/hexo.docker.key.pub <USER>@<HOST_IP>:/home/<USER>
# ===登录服务器，复制*.pub至/hexo-server/keys===
$ sudo mv /home/<USER>/hexo.docker.key.pub /hexo-server/keys
# ===服务器重启容器以载入公钥===
$ sudo docker-compose restart
```
配置config文件，定义SSH登录快捷方式
```powershell
$ nano ~/.ssh/config
Host docker.git
Hostname <YOUR_SEVER_IP>>
User git
Port 2222
IdentityFile ~/.ssh/hexo.docker.key
```
本地测试一下是否能克隆空版本库
```powershell
$ git clone ssh://docker.git/hexo-server/repos/hexo.git
# ===出现以下消息表示成功===
Cloning into 'hexo'...
warning: You appear to have cloned an empty repository.
# ===删掉刚才克隆出来的文件夹===
$ rm -rf hexo
```

# 第四步，修改本地hexo配置
```powershell
# === 修改本地hexo博客配置_conig.yml的deploy项===
...
deploy:
  type: git
  repo: docker.git:/hexo-server/repos/hexo.git
  branch: master
...
# ===现在可以将网站发布到服务器上了===
$ hexo g -d
```
