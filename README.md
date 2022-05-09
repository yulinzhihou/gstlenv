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

- 购买某云服务器，也可以使用本人的优惠券，[腾讯云](https://curl.qcloud.com/6ngsEaFu)， [阿里云](https://www.aliyun.com/minisite/goods?userCode=buoewrk0) , 算是对我的一个支持

- 同时你觉得好用，请帮忙 `star`  或者 `pr` ，让更多人看可以学习到技术

### 一、前期准备

- 安装好指定条件环境的服务器系统
- 关闭防火墙，默认需要在安全组开放指定端口 **`51888`  `33061` `13580` `15680` `21818`** 
- 如果想自己定义相应端口，则需要自己去开放对应的安全组端口号

### 二、环境安装步骤以及服务端上传启动（服务端）

- 第一步：下载部署环境的项目，使用 `root` 用户登录，**否则可能会出现报错，建议安装到 `root` 根目录**

```bash
curl -sSL https://gsgameshare.com/gsenv | bash
```

- 第二步：如果想使用默认配置(默认的端口，默认的数据库密码等)，可以跳过此步骤

```bash
# 执行此命令，进入交互配置界面
setconfig
```

- 第三步：上传服务端到 `/root` 下，服务端的名称只能是  `tlbb.tar.gz` 或者 `tlbb.zip` 否则后面的操作会报错

```bash
# 第一种方式：点击 `xshell` 软件的 `sftp` 按钮，进行 `sftp` 命令行传输模式 
# 第二种方式：用 `winscp` 软件或者其他上传软件都行，只要把服务端上传到 `/root` 目录下即可（此方法需要输入以下命令）

# 此命令只适用于 xshell 软件的 sftp 命令行窗口，请仔细查看
cd ~
put
```

- 第四步：解压上传的服务端 **（不需要考虑是哪种格式，使用此命令即可完成解压操作）**

```bash
untar
```

- 第五步：设置配置文件 **（将配置文件进行覆盖，此配置文件会按照 `.env` 文件里面定义的进行替换，没有更改的话则使用默认值）**

```bash
setini
```

- 第六步：开启服务端，等待结果

```bash
runtlbb
```

- 第七步：使用命令查看服务端运行状态

```bash
runtop
```

>   恭喜你！到此，服务端已经正确开启。
>
>   至此，服务器服务端版本开启已经完成 ，下列命令不需要逐条执行，如遇到其他问题才需要进行分步调试
>
>   只有在修改版本与调试功能的时候才需要使用下列命令进行分步开服，正常启动不需要使用以下命令。



### 三、**分步调试命令（不是修改版本，不需要使用此系列命令。只需要使用上述七个步骤即可开启服务端），此总共需要创建5个 `SSH` 标签页，然后查看哪个窗口页面里面报错，再进行修改和调试配置**

克隆 `ssh` 窗口标签页面，启动 `billing`  服务，主要用于验证游戏账号

```bash
link
step 1
```

克隆 `ssh` 窗口标签页面，启动 `ShareMemory`  游戏缓存服务，主要用于数据交换与缓存

```bash
link
step 2
```

克隆 `ssh` 窗口标签页面，启动 `Login`  游戏登录网关服务，主要用于监听账号登录相关

```bash
link
step 3
```

克隆 `ssh` 窗口标签页面，启动 `World`  游戏场景相关服务，主要用于生成游戏场景世界想着的游戏数据

```bash
link
step 4
```

克隆 `ssh` 窗口标签页面，启动 `Server`  游戏引擎服务，主要用于游戏相关配置参数的加载，并提供游戏服务

```bash
link
step 5
```

### 四、安装步骤（客户端）

- 安装最新官方[客户端](http://tl.changyou.com/download/index.shtml) ,或者下载指定版本的[客户端](http://shang.qq.com/wpa/qunwpa?idkey=a67f7a7ee8d6fb3266b945d1ec512f31a374dcb74c863ead2d73029f5050576f) （进技术交流群获取）

- 解压补丁包
- 更新补丁
- 配置单机测试使用的登录器
- 联网登录器

### 五、网站配置（服务端）

- 准备白嫖的网站原版，有能力的自己写，或者改其他人的模板。这里就不一一演示了
- 先运行 `upow` 命令后，按指定参数配置好
- 将文件上传到 **`/tlgame/www/ow`**  这个目录下面

### 六、内部集成命令


### 七、最后有如果感觉项目对你有点帮助，请支持一下我们

### 八、提供免费环境配套的视频教程。适合新手小白以及想了解本环境的流程的朋友

-   [视频配套地址](https://gsgameshare.com/gs-origin/env-v2-001)，如果访问不到，请添加Q，1303588722

-   环境配套对应的产品效果  [**GS游享网**](https://gsgameshare.com)
-   技术交流群：826717146
-   技术交流群链接：<a target="_blank" href="https://qm.qq.com/cgi-bin/qm/qr?k=7-xH1POfCRL4fYw6lJE5vNPHdjFrX4kG&jump_from=webapi"><img border="0" src="//pub.idqqimg.com/wpa/images/group.png" alt="技术整合研究所" title="技术整合研究所"></a>
-   鉴于经常搜索不到群号，特提供技术交流群扫码![](./qqqun.png)