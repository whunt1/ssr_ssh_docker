FROM debian:stretch

MAINTAINER whunt1 <whunt1@student.ccc.edu>

RUN apt-get update \
	    && apt-get -q -y dist-upgrade \
	    && apt-get -q -y install --no-install-recommends openssh-server pwgen
RUN apt-get -q -y install wget vim nano cron git curl vnstat python python-pip libssl-dev python-dev libffi-dev python-setuptools gcc libsodium-dev openssl
RUN apt-get clean \
	    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# python -m pip install cymysql
RUN wget -O /tmp/shadowsocksr.tar.gz https://github.com/NimaQu/shadowsocks/archive/manyuser.tar.gz \
		&& tar zxf /tmp/shadowsocksr.tar.gz -C /tmp \
		&& mv /tmp/shadowsocks-manyuser /usr/local/shadowsocksr \
		&& cp /usr/local/shadowsocksr/apiconfig.py /usr/local/shadowsocksr/userapiconfig.py \
		&& cp /usr/local/shadowsocksr/config.json /usr/local/shadowsocksr/user-config.json \
		&& rm -fr /tmp/shadowsocks-manyuser \
		&& rm -f /tmp/shadowsocksr.tar.gz \
		&& wget -O /tmp/ssrr.tar.gz https://github.com/LEE-Blog/shadowsocksr/archive/master.tar.gz \
		&& tar zxf /tmp/ssrr.tar.gz -C /tmp \
		&& mv /tmp/shadowsocksr-master /root/shadowsocksr \
		&& rm -fr /tmp/shadowsocksr-master \
		&& rm -f /tmp/ssrr.tar.gz
RUN rm -rf /tmp/* /var/tmp/*
RUN mkdir /var/run/sshd
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
ADD set_root_pw.sh /set_root_pw.sh
ADD superupdate.sh /superupdate.sh
ADD run.sh /run.sh
ADD autostart.sh /autostart.sh
RUN chmod +x /*.sh
# Set timezone
ENV TimeZone=Asia/Shanghai   
RUN ln -snf /usr/share/zoneinfo/$TimeZone /etc/localtime && echo $TimeZone > /etc/timezone
# Add scripts
ADD status.sh /root/status.sh
ADD brook-pf.sh /root/brook-pf.sh
RUN chmod +x /root/*.sh
# Mod vnstat
RUN service vnstat stop
RUN chown -R vnstat:vnstat /var/lib/vnstat/

EXPOSE 22
CMD ["/run.sh"]