FROM debian:latest

# env
RUN echo "export TERM=xterm-256color" >> /etc/profile
RUN echo "export LANG=C.UTF-8" >> /etc/profile
RUN echo "export LC_ALL=C.UTF-8" >> /etc/profile

# replace apt sources && install base software
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list
RUN rm /etc/apt/sources.list.d/debian.sources
RUN apt-get update && apt-get install apt-transport-https ca-certificates -y
RUN sed -i "s/http/https/g" /etc/apt/sources.list
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN apt-get update && apt-get install openssh-server wget curl nano vim tzdata dialog python3-pip sudo apt-utils git zip unzip -y
RUN dpkg-reconfigure -f noninteractive tzdata
RUN pip3 install --break-system-packages nvitop -i https://pypi.tuna.tsinghua.edu.cn/simple

# copy files
COPY Miniforge3-Linux-x86_64.sh /Miniforge3-Linux-x86_64.sh
COPY init.sh /etc/init.d/init.sh
RUN chmod +x /etc/init.d/init.sh
