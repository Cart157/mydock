# mycart的docker环境

+ 服务器：caddy
+ 代码解释器：php （workspace, fpm, worker）
+ 数据库： pgsql
+ 内存数据库：redis


workspace 有两版：
1. 默认的不带pm2，如需执行队列任务需要另外启动 worker
2. workspace-pm2，同时带有 crond 和 pm2。推荐使用第一版，第二版会节省一些硬盘空间。


### 说明：为了极速部署，没有build，只有镜像

现在镜像使用的是 aliyun 北京服务器，以后稳定了会同步到 docker 官方，使国外服务器也能很快 pull 下来


### 用法：

#### CentOS: 安装 docker-ce
```
setp1: 先删除系统中原有的 docker（请谨慎，如果不想删原有的）
-------------------------------------------------------------
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine


setp2: 安装 docker-ce 的仓库
-------------------------------------------------------------
$ sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo


setp3: 安装 docker-ce
-------------------------------------------------------------
$ sudo yum install docker-ce


setp4: 启动服务
-------------------------------------------------------------
$ sudo systemctl start docker

// 查看版本
$ docker -v


setp5: 安装 docker-compose
-------------------------------------------------------------
$ sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

$sudo chmod +x /usr/local/bin/docker-compose

// 查看版本
$ docker-compose -v
```

Ubuntu等其他系统，请参照官方教程吧<br>
https://docs.docker.com/install/linux/docker-ce/ubuntu/<br>
https://docs.docker.com/compose/install/

#### 启动 mydock

1. 先下载 `git clone https://github.com/Cart157/mydock.git`
2. `cd mydock`
3. `docker-compose up -d caddy pgsql redis`，因为 caddy 会依赖 `php-fpm`，所以 `php-fpm` 和 `workspace` 会被自动启动，`pgsql redis worker` 等请按需启动

### TODO

- [ ] 注掉 mysql 换成 alpine 版的 mariadb 10 （相当于 mysql 5.7，因为 mysql 不能在 alpine 下编译，一个镜像400M太大了）
- [ ] 把 pgsql 弄好，测通
- [ ] 把 ssh mysql pgsql redis 的密码都统一放在 docker-compose.yml 里设置
- [ ] 把 pm2 的 web 查看弄好，测通后删掉 worker 的 ssh

### 备用

- [X] checkbox
