FROM debian:latest

# env
ENV TERM xterm-256color

# replace apt sources && install base software
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list
RUN rm /etc/apt/sources.list.d/debian.sources
RUN apt-get update && apt-get install apt-transport-https ca-certificates -y
RUN sed -i "s/http/https/g" /etc/apt/sources.list
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN apt-get update && apt-get install openssh-server wget curl nano vim tzdata dialog python3-pip sudo apt-utils git -y
RUN dpkg-reconfigure -f noninteractive tzdata

# add user
ARG username
ARG password
RUN useradd -u 999 -ms /bin/bash $username
RUN echo "$username:$password" | chpasswd
RUN usermod -a -G sudo $username
USER $username
WORKDIR /home/$username

# install nvitop for user
RUN pip3 install --break-system-packages nvitop -i https://pypi.tuna.tsinghua.edu.cn/simple

# install conda
COPY Miniforge3-Linux-x86_64.sh Miniforge.sh
RUN bash Miniforge.sh -b
RUN ~/miniforge3/bin/conda init
RUN ~/miniforge3/bin/mamba init
RUN rm Miniforge.sh

# swich into root
USER root
RUN echo "#!/bin/bash\n/etc/init.d/ssh start\n/bin/bash" > /etc/init.d/init.sh
RUN chmod +x /etc/init.d/init.sh

# run terminal
CMD ["/etc/init.d/init.sh"]
