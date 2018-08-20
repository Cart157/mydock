# mycart的docker环境

+ 服务器：caddy
+ 代码解释器：php （workspace, fpm, worker）
+ 数据库： pgsql
+ 内存数据库：redis


## 为了极速部署，没有build，只有镜像

现在镜像使用的是 aliyun 北京服务器，以后稳定了会同步到 docker 官方，使国外服务器也能很快 pull 下来


## TODO

- \[] 把 mysql 换成 alpine 版的 mariadb 10 （相当于 mysql 5.7）
- \[] 把 pgsql 弄好
- \[] 把 pm2 的 web 查看弄好

## 备用

- \[X] checkbox
