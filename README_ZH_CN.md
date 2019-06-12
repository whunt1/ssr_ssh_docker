# ssr_ssh_docker
内置 ssh 和 ssr 的 Debian9 docker 镜像
   
使用ssr魔改版后端
```bash
包含以下软件包: 
openssh-server 
pwgen 
wget 
vim 
nano 
cron 
git 
python 
python-pip 
libssl-dev 
python-dev 
libffi-dev 
python-setuptools 
gcc 
libsodium-dev 
openssl 
cymysql 
```
ssr_uim 面板源码地址: https://github.com/NimaQu/shadowsocks

## 快速使用

安装 docker：
```bash
wget -qO- https://get.docker.com/ | sh
```
运行 docker:
```bash
# CentOS
systemctl enable docker
systemctl start docker
# Debian/Ubuntu
service docker start
```
建立镜像并启动镜像，其中 2333 为你的 ssh 端口，ssr_docker 为容器名称:
```bash
docker pull whuntssr/ssr_ssh_docker:latest
docker run -d -p 2333:22 --name ssr_docker --restart=always whuntssr/ssr_ssh_docker
docker logs ssr_docker
```
您将看到如下输出，其中包含 root 密码（如：qJixrU8ToNxe4xRg）：
```bash
========================================================================
You can now connect to this debian9 container via SSH using:

    ssh -p <port> root@<host>
and enter the root password 'qJixrU8ToNxe4xRg' when prompted
	
Please remember to change the above password as soon as possible!
========================================================================

In this case, `qJixrU8ToNxe4xRg` is the password allocated to the `root` user.

Done!
```
## 关于镜像

根目录的`/autostart.sh`是一个开机启动脚本，您可以在其中添加您的命令。

它将在 docker 启动时运行。

还有一个“ssrKeeper”的脚本，在目录`/usr/local/shadowsocksr/runssr.sh`中。

它的用法参考：https://github.com/whunt1/ssrkeeper

此外 iptables 的设置方法参考：https://github.com/whunt1/docker_manage_port

## 用法
要使用最新的Debian发行版创建映像 ssr_ssh_docker ，请执行以下操作：

在 debian9_docker_sshd 文件夹下执行以下命令：
```bash
git clone https://github.com/whunt1/ssr_ssh_docker.git && cd ssr_ssh_docker
docker build -t whuntssr/ssr_ssh_docker . 
```
## 运行 SSR_ssh_docker。
要将容器的22端口映射到主机的2333端口，请执行以下操作：
```bash
docker run -d -p 2333:22 whuntssr/ssr_ssh_docker
```
第一次运行容器时，将生成一个随机密码。
对于用户`root`要获取密码，请运行以下命令检查docker的日志：
```bash
docker logs <CONTAINER_ID>
```
您将看到如下输出：
```bash
========================================================================
You can now connect to this debian9 container via SSH using:

    ssh -p <port> root@<host>
and enter the root password 'qJixrU8ToNxe4xRg' when prompted
	
Please remember to change the above password as soon as possible!
========================================================================

In this case, `qJixrU8ToNxe4xRg` is the password allocated to the `root` user.

Done!
```

## 为 root 帐户设置特定密码。

如果要使用预设密码而不是随机生成的密码，可以。
在运行容器时，将环境变量`root_pass`设置为您的特定密码：
```bash
docker run -d -p 2333:22 -e ROOT_PASS="rootpasswd" whuntssr/ssr_ssh_docker
```
