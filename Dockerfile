# easy-mock all in one.
FROM node:8

LABEL version="1.6.0" \ 
      maintainer="jptx1234@gmail.com"
      
ENV EASY_MOCK_VERSION 1.6.0

WORKDIR /root/easy_mock

# 安装mongodb、redis、easy-mock
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
      echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list && \
      apt-get update && \
      mkdir -p /data/db && \
      apt-get install -y mongodb-org mongodb-org && \
      # 安装redis
      apt install -y redis-server && \
      # 安装easy-mock
      wget --no-check-certificate -O easy_mock.tar.gz https://github.com/easy-mock/easy-mock/archive/v${EASY_MOCK_URL}.tar.gz && \
      tar -xzvf easy_mock.tar.gz --strip-components 1 && \
      rm -f easy_mock.tar.gz && \
      yarn install && \
      yarn run build && \
      yarn global add pm2 && \
      yarn cache clean 
 
 # 暴露端口7300
 EXPOSE 7300
 # 设置镜像默认启动命令
 CMD ["mongod", "--bind_ip_all", "--fork", "--logpath", "/dev/null", "&&", "redis-server", "--protected-mode", "no", "--daemonize", "no", "&&", "pm2-docker", "start", "app.js"]
 
