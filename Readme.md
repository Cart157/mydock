# mycart的docker环境

+ 服务器：caddy
+ 代码解释器：php 7.1 （workspace, fpm, worker）
+ 数据库： pgsql 10.0
+ 内存数据库：redis 3.2


### 说明：为了极速部署，没有build，只有镜像

1. 现在镜像使用的是 aliyun 北京服务器，以后稳定了会同步到 docker 官方，使国外服务器也能很快 pull 下来

2. workspace 有两版：
    1. 默认版只有 crond，没有 pm2，如需执行队列任务需要另外启动 worker
    2. workspace-pm2版，同时带有 crond 和 pm2。推荐使用第一版（符合 docker 的设计原则），但第二版会节约一些硬盘空间。

3. 保留 mariadb 和 mysql 给有需要的人

4. 站点配置，在 `caddy/conf/vhost` 里

5. 权限说明：php使用的官方镜像作为基础，使用 `www-data` 用户运行，gid和uid都是82，所以网站的根目录应该 `chown -R 82:82 path` path指的是网站的目录

6. pm2 的配置文件，放在 www 下，可以配置多个站点

7. 如果放在外网，**记得在 docker-compose.yml 里修改密码**，还有最好不要把 db 和 redis 的端口映射出去，通过 workspace 的 ssh 连接它们


### 用法：

#### CentOS: 安装 docker-ce
```
setp1: 先删除系统中原有的 docker（请谨慎，如果不想删原有的）
-------------------------------------------------------------
$ yum remove docker \
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
$ yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

$ yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo


setp3: 安装 docker-ce
-------------------------------------------------------------
$ yum install docker-ce


setp4: 启动服务
-------------------------------------------------------------
$ systemctl start docker

// 查看版本
$ docker -v


setp5: 安装 docker-compose
-------------------------------------------------------------
$ curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

$ chmod +x /usr/local/bin/docker-compose

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


### 打开防火墙的端口

因为有些服务的端口映射到了宿主机上（例如：workspace映射到2222），所以需要打开防火墙的端口，阿里云的话是设置“安全组策略”

CentOS7: firewalld
```
// 永久打开 2222 端口
$ firewall-cmd --add-port=2222/tcp --permanent

// 使服务生效
$ systemctl restart firewalld

// 检查设置是否生效
# iptables -L -n | grep 2222
```

CentOS6: iptables
```
// 打开 2222 端口
$ iptables -A INPUT -p tcp --dport 2222 -j ACCEPT

// 保存规则（永久打开）
$ service iptables save
$ service iptables restart

// 检查设置是否生效
# iptables -L -n | grep 2222
```


### TODO

- [X] 注掉 mysql 换成 alpine 版的 mariadb 10 （相当于 mysql 5.7，因为 mysql 不能在 alpine 下编译，一个镜像400M太大了）
- [X] 把 pgsql 弄好，测通
- [ ] 把 ssh mysql pgsql redis 的密码都统一放在 docker-compose.yml 里设置
- [ ] 把 pm2 的 web 查看弄好，测通后删掉 worker 的 ssh
