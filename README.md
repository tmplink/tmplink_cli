# 钛盘 CLI 工具 (beta)
此工具帮助你在 Linux 环境下，快速上传多个文件。  
它是基于 dialog 的 GUI 工具，支持中文。

## 安装依赖项目
目前需要安装 diglog 和 curl 两个项目。 

### 基于 yum 和 dnf 的系统
```bash
sudo yum install dialog curl
```

### 基于 apt 的系统
```bash
sudo apt install dialog curl
```

## 安装
```bash
sudo curl -o "/usr/bin/tmpup" "https://raw.githubusercontent.com/tmplink/tmplink_cli/main/src/tmpup_cn.sh"
sudo chmod +x /usr/bin/tmpup
```

## 使用
### 设定 Token
首先，你需要登录钛盘，然后点击上传按钮，选择好上传有效期后，看到上传文件按钮的同时，你可以看到 “使用命令行上传文件” 的选项，点击它，然后复制 cli 上传命令。  

接下来你可以在上传命令中找到 token=... ，这就是你的 token 了。  
然后，在你的 linux 系统中，创建文件 /etc/tmplink_cli.cfg ，写入 token 内容。

### tmpup 的参数
```bash
tmpup [-m][-r]
    m : model, 模式，可选值为 0,1,2,99
        0 : 限时24小时
        1 : 自动续期模式，有效期 1 天
        2 : 自动续期模式，有效期 7 天
        99: 上传至私有空间，无有效期
    r : mrid,设定此值时，文件会上传到指定的文件夹，不设定则为上传至仓库。
```

### 上传到文件夹
上传到文件夹需要指定 mrid 这个值同样时在获取 token 的地方获取，你需要先进入到具体的文件夹，然后再用一样的方法获得 cli 上传命令，然后可以找到 mrid=... ，这就是文件夹的 mrid 了。