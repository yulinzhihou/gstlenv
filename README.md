## 项目支持

查看支持的服务器系统版本 

| Platform                                                   | x86_64 / amd64                                               | ARM                                                          | ARM64 / AARCH64                                              | Version |
| :--------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- | ------- |
| <a href="https://docs.docker.com/engine/install/centos/" target="_blank" rel="nofollow noopener">CentOS</a>   | ![](https://docs.docker.com/assets/images/green-check.svg)|                                                              | ![](https://docs.docker.com/assets/images/green-check.svg) | 7+      |
| <a href="https://docs.docker.com/engine/install/debian/" target="_blank" rel="nofollow noopener">Debian</a>  | ![](https://docs.docker.com/assets/images/green-check.svg) | ![](https://docs.docker.com/assets/images/green-check.svg) | ![](https://docs.docker.com/assets/images/green-check.svg) | 9+      |
| <a href="https://docs.docker.com/engine/install/Fedora/" target="_blank" rel="nofollow noopener">Fedora</a>  | ![](https://docs.docker.com/assets/images/green-check.svg)|                                                              | ![](https://docs.docker.com/assets/images/green-check.svg) | 32+     |
| <a href="https://docs.docker.com/engine/install/Raspbian/" target="_blank" rel="nofollow noopener">Raspbian</a>  |                                                              | [](https://docs.docker.com/assets/images/green-check.svg) | ![](https://docs.docker.com/assets/images/green-check.svg) | 9+      |
| <a href="https://docs.docker.com/engine/install/ubuntu/" target="_blank" rel="nofollow noopener">Ubuntu</a>   | ![](https://docs.docker.com/assets/images/green-check.svg) | ![](https://docs.docker.com/assets/images/green-check.svg) | ![](https://docs.docker.com/assets/images/green-check.svg) | 16.04+

- 本教程支持各种云服务器

- 增加敏感配置项可以自定义，简单方便。如：数据库密码，端口等

- 集成分步调试开服的命令，可以更好的排错

- 本操作手册仅供学习使用，请勿用于商业用途，如有侵权，请与本人联系！

### 前期准备

- 安装好指定条件环境的服务器系统
- 关闭防火墙，默认需要在安全组开放指定端口 **`51888`  `33061` `13580` `15680` `21818`** 
- 如果想自己定义相应端口，则需要自己去开放对应的安全组端口号

## 快速入门

### 视频教程(小白新手快速从0到1)
- [第一课：服务器环境安装（虚拟机+云主机）](https://www.bilibili.com/video/BV1oN411y7r7/)
- [第二课：本机运行环境的准备工作](https://www.bilibili.com/video/BV1Jh411c7ud/)
- [第三课：安装 GS 环境并架设服务端程序](https://www.bilibili.com/video/BV1eu4y1f7Pd/)
- [第四课：安装客户端及更新补丁](https://www.bilibili.com/video/BV1Cz4y1B7RU/)
- [第五课：GM工具使用](https://www.bilibili.com/video/BV1Gh411c7GD/)
- 第六课：其他功能介绍与展示

### 一、环境安装步骤以及服务端上传启动（服务端）

- 第 1 步：下载部署环境的项目，使用 `root` 用户登录，**否则可能会出现报错，建议安装到 `root` 根目录**

对于 `github` 用户
```bash
curl -sSL https://gitee.com/yulinzhihou/gstlenv/raw/master/gsenv.sh | bash
```

- 第 2 步：**如果想使用默认配置(默认的端口，默认的数据库密码等)，可以跳过此步骤**

```bash
# 执行此命令，进入交互配置界面
setconfig
```

- 第 3 步：上传服务端到 `/root` 下，服务端的名称只能是  `tlbb.tar.gz` 或者 `tlbb.zip` 否则后面的操作会报错

```bash
# 第一种方式：点击 `xshell` 软件的 `sftp` 按钮，进行 `sftp` 命令行传输模式 
# 第二种方式：用 `winscp` 软件或者其他上传软件都行，只要把服务端上传到 `/root` 目录下即可（此方法需要输入以下命令）

# 此命令只适用于 xshell 软件的 sftp 命令行窗口，请仔细查看
cd ~
put
```

- 第 4 步：解压上传的服务端 **（不需要考虑是哪种格式，使用此命令即可完成解压操作）**

```bash
untar
```

- 第 5 步：设置配置文件 **（将配置文件进行覆盖，此配置文件会按照 `.env` 文件里面定义的进行替换，没有更改的话则使用默认值）**

```bash
setini
```

- 第 6 步：开启服务端，等待结果

```bash
runtlbb
```

- 第 7 步：使用命令查看服务端运行状态

```bash
runtop
```

>   恭喜你！到此，服务端已经正确开启。
>
>   至此，服务器服务端版本开启已经完成 ，下列命令不需要逐条执行，如遇到其他问题才需要进行分步调试
>
>   只有在修改版本与调试功能的时候才需要使用下列命令进行分步开服，正常启动不需要使用以下命令。


### 二、安装步骤（客户端）

- 安装最新官方[客户端](http://tl.changyou.com/download/index.shtml) ,或者下载指定版本的[客户端](https://qm.qq.com/cgi-bin/qm/qr?k=U88GIGoFjAcy9kkX3hJ-Xv0qRvSXB3ej) （进技术交流群:234788882 获取）

- 解压补丁包
- 更新补丁
- 配置单机测试使用的登录器
- 联网登录器

### 三、网站配置（服务端）

- 准备网站源代码文件，有能力的自己写。
- 先运行 `upow` 命令后，按指定参数配置好
- 将文件上传到 **`/tlgame/www/ow`**  这个目录下面

### 四、内部集成命令
- 使用 `gs` 命令进入命令帮助提示

### 五、最后有如果感觉项目对你有点帮助，请支持一下我们
| 支付宝扫码捐赠    | 微信支付捐赠         |
| ----------------- | -------------------- |
| ![](alipay.png) | ![](wechatpay.png) |

### 六、提供免费环境配套的视频教程。适合新手小白以及想了解本环境的流程的朋友
-   技术交流群：234788882
-   有需要可以进电报群（PS:不经常看）[https://t.me/gstlenv](https://t.me/gstlenv)


### 七、常见问题集合

[https://github.com/yulinzhihou/gstlenv/wiki](https://github.com/yulinzhihou/gstlenv/wiki)
[https://gitee.com/yulinzhihou/gstlenv/wiki](https://gitee.com/yulinzhihou/gstlenv/wiki)