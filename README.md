# ssr_ssh_docker
Debian9 docker image with sshd and ssr

> [中文文档](https://github.com/whunt1/ssr_ssh_docker/blob/master/README_ZH_CN.md)

SSR images with SSH access
```bash
include: 
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
ssr_uim: https://github.com/NimaQu/shadowsocks

## Easy Usage

Install Docker:
```bash
wget -qO- https://get.docker.com/ | sh
```
Run docker:
```bash
# CentOS
systemctl enable docker
systemctl start docker
# Debian/Ubuntu
service docker start
```
Build and run image:
```bash
docker pull whuntssr/ssr_ssh_docker:latest
docker run -d -p 2333:22 --name ssr_docker --restart=always whuntssr/ssr_ssh_docker
docker logs ssr_docker
```
You will see an output like the following:
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
## About Image

There is a startup bash at `/autostart.sh`, you can add your commands in it.

It will run at the docker container start.

Also there is a "ssrkeeper" bash at `/usr/local/shadowsocksr/runssr.sh`

Its usage is here: https://github.com/whunt1/ssrkeeper

In addition, iptables usage is here: https://github.com/whunt1/docker_manage_port

## Usage

To create the image `ssr_ssh_docker` with latest Debian release, 
execute the following commands on the debian9_docker_sshd folder:
```bash
git clone https://github.com/whunt1/ssr_ssh_docker.git && cd ssr_ssh_docker
docker build -t whuntssr/ssr_ssh_docker . 
```
## Running ssr_ssh_docker

To run a container from the image binding it to port 2333 in all interfaces, execute:
```bash
docker run -d -p 2333:22 whuntssr/ssr_ssh_docker
```
The first time that you run your container, a random password will be generated
for user `root`. To get the password, check the logs of the container by running:
```bash
docker logs <CONTAINER_ID>
```
You will see an output like the following:
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

## Setting a specific password for the root account

If you want to use a preset password instead of a random generated one, you can
set the environment variable `ROOT_PASS` to your specific password when running the container:
```bash
docker run -d -p 2333:22 -e ROOT_PASS="rootpasswd" whuntssr/ssr_ssh_docker
```

