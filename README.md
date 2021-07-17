## 全新手工架设环境开服食用指南

- 查看支持的服务器系统版本 

| Platform                                                   | x86_64 / amd64                                               | ARM                                                          | ARM64 / AARCH64                                              | Version |
| :--------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- | ------- |
| [CentOS](https://docs.docker.com/engine/install/centos/)   | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/centos/) |                                                              | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/centos/) | 7+      |
| [Debian](https://docs.docker.com/engine/install/debian/)   | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/debian/) | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/debian/) | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/debian/) | 9+      |
| [Fedora](https://docs.docker.com/engine/install/fedora/)   | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/fedora/) |                                                              | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/fedora/) | 32+     |
| [Raspbian](https://docs.docker.com/engine/install/debian/) |                                                              | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/debian/) | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/debian/) | 9+      |
| [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)   | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/ubuntu/) | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/ubuntu/) | [![yes](https://docs.docker.com/images/green-check.svg)](https://docs.docker.com/engine/install/ubuntu/) | 16.04+  |

- 本教程支持各种云服务器

- 增加敏感配置项可以自定义，简单方便。如：数据库密码，端口等

- 集成分步调试开服的命令，可以更好的排错

- 本操作手册仅供学习使用，请勿用于商业用途，如有侵权，请与本人联系！

- 购买某云服务器，也可以使用本人的优惠券，[腾讯云](https://url.cn/gWNWl5N8)， [阿里云](https://www.aliyun.com/minisite/goods?userCode=buoewrk0) , 算是对我的一个支持

- 同时你觉得好用，请帮忙 `star`  或者 `pr` ，让更多人看可以学习到技术

### 一、前期准备

- 安装好指定条件环境的服务器系统
- 关闭防火墙，默认需要在安全组开放指定端口 **`8080`  `33061` `13580` `15680`** 
- 如果想自己定义相应端口，则需要自己去开放对应的安全组端口号

### 二、安装步骤（服务端）

- 第一步：下载部署环境的项目，使用 `root` 用户登录，**否则可能会出现报错，建议安装到 `root` 根目录**

```bash
wget -q https://gsgameshare.com/gsenv.sh -O gsenv && /bin/bash gsenv
```

- 第二步：完成第一步的安装结果后，会弹出提示，`gstl`  使用此命令进行游戏服务端的安装与常用配置参数的配置

```bash
gstl
```

- 第三步：如果小服务器配置，如`1G` `2G` 内存的，需要拓展一下虚拟内存，才能流畅跑起服务端**(注：此步骤超过4G内存的服务器可以不用管，必须保证服务器硬盘总容量有20G以上才能使用。不是空余空间，是总共有20G
以上的就可以使用) ** **强烈建议不管多大内存，都需要开启一下，毕竟不要钱，只占一点空间而已**。

```bash
swap
```

- 第四步：上传服务端到 `/root` 下，点击 `xshell` 软件的 `sftp` 按钮，进行 `sftp` 命令行传输模式**（注：用 `winscp` 软件或者其他上传软件都行，只要把服务端上传到 `/root` 目录下即可，服务端的名称只能是  `tlbb.tar.gz` 或者 `tlbb.zip` 否则后面的操作会报错）**

```bash
cd ~
```

```BASH
put
```

- 第五步：解压上传的服务端 **（不需要考虑是哪种格式，使用此命令即可完成解压操作）**

```bash
untar
```

- 第六步：设置配置文件**（将配置文件进行覆盖，此配置文件会按照 `env-example` 文件里面定义的进行替换，没有更改的话则使用默认值）**

```bash
setini
```

- 第七步：开启服务端，等待结果

```bash
runtlbb
```

- 使用命令查看服务端运行状态

```bash
runtop
```

### 三、**分步调试命令，总共需要创建5个 `SSH` 标签页，然后查看哪个窗口页面里面报错，再进行修改和调试配置** 

克隆 `ssh` 窗口标签页面，启动 `billing`  服务，主要用于验证游戏账号

```bash
step 1
```

克隆 `ssh` 窗口标签页面，启动 `ShareMemory`  游戏缓存服务，主要用于数据交换与缓存

```bash
step 2
```

克隆 `ssh` 窗口标签页面，启动 `Login`  游戏登录网关服务，主要用于监听账号登录相关

```bash
step 3
```

克隆 `ssh` 窗口标签页面，启动 `World`  游戏场景相关服务，主要用于生成游戏场景世界想着的游戏数据

```bash
step 4
```

克隆 `ssh` 窗口标签页面，启动 `Server`  游戏引擎服务，主要用于游戏相关配置参数的加载，并提供游戏服务

```bash
step 5
```

- 修改环境更改端口，密码等，用于换端命令，执行完后建议重启服务器。

```bash
//进行交互式设计，配置端口，密码等
setconfig
```

```bash
//上面交互设置完成后，再执行此命令
rebuild
```



### 四、安装步骤（客户端）

- 安装最新官方[客户端](http://tl.changyou.com/download/index.shtml) ,或者下载指定版本的[客户端](http://shang.qq.com/wpa/qunwpa?idkey=a67f7a7ee8d6fb3266b945d1ec512f31a374dcb74c863ead2d73029f5050576f) （进技术交流群获取）

- 解压补丁包
- 更新补丁
- 配置单机测试使用的登录器
- 联网登录器

### 五、网站配置（服务端）

- 准备白嫖的网站原版，有能力的自己写，或者改其他人的模板。这里就不一一演示了
- 将文件上传到 **`/tlgame/www`**  这个目录下面

### 六、内部集成命令

| 命令名称  | 描述                                                         | 执行条件（环境）                                    |
| --------- | ------------------------------------------------------------ | --------------------------------------------------- |
| untar     | 解压服务端压缩包，暂时只支持 `tar.gz` 和 `zip` 压缩包        | 服务端压缩包必须上传到 `/root` 目录下               |
| setini    | 自动设置服务器配置文件，3个 `ini` 文件，以及数据库连接和 `billing` 文件 | 必须要解压了服务端压缩包后执行                      |
| runtlbb   | 运行一键服务端命令，会调用 `run.sh` 脚本，如果运行不成功，则可能是服务端有问题 | 必须在 `setini` 命令后执行，或者重启服务器后        |
| runtop    | 查看各容器之间的 top 命令信息                                | 用于查看开服是否成功                                |
| link      | 默认命令进行服务端所在的容器里面，此容器里面，以上所有命令都无法使用，要使用则需要退出容器，使用 `exit` 指令即可退出 | 用于进入容器，查看服务端的具体情况，或者是分步调试  |
| swap      | 增加云服务器或者虚拟机系统的虚拟内存，默认增加 4GB 虚拟内存。只是占用硬盘空间，不需要多次执行，但此命令是临时生效，重启服务器后需要再次执行 | 小于或等于 5GB 内存的虚拟机或者服务器配置，需要使用 |
| rebuild   | 删除当前容器，当前物理机所存储的数据，相当于换端使用         |                                                     |
| remove    | 删除所有已经构建好的数据，需要重新安装环境和配置文件         | 服务器环境错乱了，相当于重装系统                    |
| setconfig | 重新配置命令参数，按提示进行设置，设置完成后，需要配合  `setini` ` +  ` `rebuild`   命令才会生效 | 注意需要备份服务端数据与数据库数据                  |
| change    | 执行此命令，即可完成更换服务端操作，数据库不会清除，原服务端版本的数据还会存在。建议不要使用相同账号进入，可能会报错 | 服务端压缩包必须上传到 `/root` 目录下               |
| restart   | 重启环境，不会清空数据，只是相当于重启服务端                 | -                                                   |
| gsbak     |                                                              |                                                     |
| upcmd     |                                                              |                                                     |
| upgm      |                                                              |                                                     |
| upow      |                                                              |                                                     |
| step      |                                                              |                                                     |
| gs        |                                                              |                                                     |
| gstl      |                                                              |                                                     |
|           |                                                              |                                                     |



### 七、最后有如果感觉项目对你有点帮助，请支持一下我们



-   环境配套对应的产品效果  [**GS游享网**](https://gsgameshare.com)
-   技术交流群：826717146
-   技术交流群链接：<a target="_blank" href="https://qm.qq.com/cgi-bin/qm/qr?k=7-xH1POfCRL4fYw6lJE5vNPHdjFrX4kG&jump_from=webapi"><img border="0" src="//pub.idqqimg.com/wpa/images/group.png" alt="技术整合研究所" title="技术整合研究所"></a>
-   鉴于经常搜索不到群号，特提供技术交流群扫码![](./qqqun.png)