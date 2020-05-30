---
# 常用定义
title: "ssh 远程监控工具"           # 标题
date: 2020-05-30T04:01:23+08:00    # 创建时间
lastmod: 2020-05-30T04:01:23+08:00 # 最后修改时间
draft: false                       # 是否是草稿？
tags: ["golang", "ssh"]  # 标签
categories: ["ssh"]              # 分类
author: "xiexiaojun"                  # 作者

weight: 1

# 用户自定义
# 你可以选择 关闭(false) 或者 打开(true) 以下选项
comment: true   # 评论
toc: true       # 文章目录
reward: true	 # 打赏
mathjax: true    # 打开 mathjax

------

# [jump](https://github.com/xxjwxc/jump/)

remote monitoring . 远程监控工具

# 支持
- 默认配置 (jump config),保存公共配置
- 登录(jump in),远程登录(支持tab键)
- 监控(jump run),远程监控(支持登录命令行预执行，支持文件监控,tail -f)
- ptrace 远程进程调试


## 设置配置文件(jump config)

```
./jump config -d=~ -i=127.0.0.1 -p=123456 -u=ubuntu -P=22 -c="cd /var/log/,ls,ll"
```

### 更多：
```
./jump config -h
```

## 远程登录(jump in)

```
./jump in
```

## 远程监控(jump run)

```
./jump run -f=nginx/access.log
```

- 支持预定义命令

./jump config -c = "cd /var/log/,ls,ll" 添加

### 更多：
```
./jump run -h
```

# SSH ==> [myssh](https://github.com/xxjwxc/public/blob/master/myssh/myssh.go)

# [感谢您的点星支持](https://github.com/xxjwxc/jump/)
