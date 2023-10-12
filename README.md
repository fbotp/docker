# 使用Docker实现基础容器用于深度学习开发
## 构建镜像
- 下载Miniforge到本地，确保文件名为`Miniforge3-Linux-x86_64.sh`，如果想使用其他conda软件需修改`Dockerfile`对应`install conda`部分，之后使用build命令构建
  ```bash
  docker build . --build-arg user=用户名 --build-arg password=密码 -t 镜像名:latest
  ```
## 运行容器(docker run或docker-compose)
- ### docker run
  ```bash
  docker run -dit --gpus all -p ssh宿主机开放端口:22 -h 容器主机名 --shm-size 8g --name=容器名 --pid=host 镜像名 /bin/bash
  ```
- ### docker compose
  ```bash
  docker-compose up -d
  ```