# mycart的docker环境

+ 服务器：caddy
+ 代码解释器：php （workspace, fpm, worker）
+ 数据库： pgsql
+ 内存数据库：redis


### 为了极速部署，没有build，只有镜像

现在镜像使用的是 aliyun 北京服务器，以后稳定了会同步到 docker 官方，使国外服务器也能很快 pull 下来


### TODO

- [ ] 注掉 mysql 换成 alpine 版的 mariadb 10 （相当于 mysql 5.7，因为 mysql 不能在 alpine 下编译，一个镜像400M太大了）
- [ ] 把 pgsql 弄好，测通
- [ ] 把 ssh mysql pgsql redis 的密码都统一放在 docker-compose.yml 里设置
- [ ] 把 pm2 的 web 查看弄好，测通后删掉 worker 的 ssh

### 备用

- [X] checkbox
