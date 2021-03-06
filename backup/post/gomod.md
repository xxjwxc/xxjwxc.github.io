---
# 常用定义
title: "go mod相关配置及说明"           # 标题
date: 2019-09-22T16:16:40+08:00    # 创建时间
lastmod: 2019-09-22T16:16:40+08:00 # 最后修改时间
draft: false                       # 是否是草稿？
tags: ["golang", "mod", "配置"]  # 标签
categories: ["工具"]              # 分类
author: "xiexiaojun"                  # 作者

weight: 1

# 用户自定义
# 你可以选择 关闭(false) 或者 打开(true) 以下选项
comment: true   # 评论
toc: true       # 文章目录
reward: true	 # 打赏
mathjax: true    # 打开 mathjax

---

## golang Modules 的最新命令说明

#### 创建一个新的模块

```
go mod init [本项目mod名]
```
### 列出当前模块所有依赖项

```
go get -u github.com/xxjwxc/public@[版本号,保持最新请使用latest 或者 master]
```

- 说明 go get -u 来保持最新，测试下来需要等待几分钟才同步的下来。

```
go get -u github.com/xxjwxc/public@master
```

#### 清除依赖项

```
go mod tidy

```

#### 清理本地缓存
```
go clean -modcache 
```

#### 添加本地项目
go.mod 中添加
```
require github.com/xxjwxc/public v0.0.0-incompatible
replace github.com/xxjwxc/public => ../public
```

## 实战

 - 添加一个库保持最新[github.com/xxjwxc/public] 使用MakeFile 及 go:generate 实现

 1. 添加 gogenerate.go
 ```
 package main

//go:generate make gen

 ```

 2. 添加 MakeFile

```
regen:
	go clean -modcache #清理本地缓存
gen:
	go get -u github.com/xxjwxc/public@master # 保持最新
	go mod tidy
```

说明:为了保持最新可以手动设置版本信息
一般不带tag标签的版本是：

github.com/xxjwxc/public v0.0.0-20190911032541-5d814c6ef57d

其中：20190911032541 表示时间戳 
5d814c6ef57d 表示commit版本号

可以通过 git log查看信息
不过 20190911032541 中相差8个小时
git log 对应 20190919032541

3. 启动

```
go generate & go build ./main.go

or

make gen
```

[参考链接](https://mp.weixin.qq.com/s/v-NdYEJBgKbiKsdoQaRsQg)

## [喜欢请给星](https://github.com/xxjwxc)

----------
