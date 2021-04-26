---
# 常用定义
title: "consul 自动配置工具"           # 标题
date: 2021-04-26T10:01:23+08:00    # 创建时间
lastmod: 2021-04-26T10:01:23+08:00 # 最后修改时间
draft: false                       # 是否是草稿？
tags: ["golang", "consul", "tools"]  # 标签
categories: ["工具"]              # 分类
author: "xxjwxc"                  # 作者

weight: 1

# 用户自定义
# 你可以选择 关闭(false) 或者 打开(true) 以下选项
comment: true   # 评论
toc: true       # 文章目录
reward: true	 # 打赏
mathjax: true    # 打开 mathjax

---

## [consult](https://github.com/xxjwxc/consult)

### 前言

- [consult](https://github.com/xxjwxc/consult) 是对[consul](https://github.com/hashicorp/consul)的二次封装，方便用户使用，
- [consult](https://github.com/xxjwxc/consult) 提供一系列函数操作consul
- [consult](https://github.com/xxjwxc/consult) 支持watcher
- [consult](https://github.com/xxjwxc/consult) 支持`tag`标签自动获取/自动更新

## 使用

### 安装
```
go get -u github.com/xxjwxc/consult@master
```

### 新建一个连接
```golang
import (
	"github.com/xxjwxc/consult/consulkv"
)

conf := consulkv.NewConfig()
```
or 

### With Options
```golang
conf := consulkv.NewConfig(
    consulkv.WithPrefix(prefix),             // consul kv 前缀
    consulkv.WithAddress(address),           // consul 地址
    consulkv.WithAuth(username, password),   // cosul 用户密码
    consulkv.WithToken(token),               // cousl token
    consulkv.WithLoger(loger),               // loger
)

```


### Init
```golang
if err := conf.Init();err !=nil {
    return err
}
```

### Put
```golang
if err := conf.Put(key, value);err !=nil {
    return err
}
```

### Delete
```golang
if err := conf.Delete(key);err !=nil {
    return err
}
```

### Get

```golang
// scan
if err := conf.Get(key).Scan(x);err !=nil {
    return err
}

// get float
float := conf.Get(key).Float()

// get float with default
float := conf.Get(key).Float(defaultFloat)

// get int
i := conf.Get(key).Int()

// get int with default
i := conf.Get(key).Int(defaultInt)

// get uint
uInt := conf.Get(key).Uint()

// get uint with default
uInt := conf.Get(key).Uint(defaultUint)

// get bool
b := conf.Get(key).Bool()

// get bool with default
b := conf.Get(key).Bool(defaultBool)

// get []byte
bytes := conf.Get(key).Bytes()

// get uint with default
bytes := conf.Get(key).bytes(defaultBytes)

// get string
str := conf.Get(key).String()

// get string with default
str := conf.Get(key).String(defaultStr)

// get time
t := conf.Get(key).Time()

// get time with default
t := conf.Get(key).Time(defaultTime)

// get nested key values
conf.Get(key).Get(nextKey1).Get(nextKey2).String()
```

### 监听
```golang
conf.Watch(path, func(r *Result){
    r.Scan(x)
})

```

### 停止监听
```golang
// stop single watcher
conf.StopWatch(path)

// stop multiple watcher
conf.StopWatch(path1, path2)

// stop all watcher
conf.StopWatch()
```

### 通过tag自动获取/自动更新

- 定义变量时添加`consul:""`标签进行自动注册及获取

```go
import (
	"github.com/xxjwxc/consult"
)

type Info struct {
    Port  string  `yaml:"port" consul:"port"` // 端口号
}

var info Info
consult.AutoLoadConfig(conf, &info) //  自动加载

consult.AutoSetConfig(conf, &info, false) // 执行一次自动更新

```

## 完整例子
```go 

import (
	"fmt"
	"testing"

	"github.com/xxjwxc/consult/consulkv"
    "github.com/xxjwxc/consult"
)

type Config struct {
	MySQLInfo    MysqlDbInfo `yaml:"mysql_info" consul:"mysql_info"`
	Port         string      `yaml:"port" consul:"port"`                   // 端口号
}

// MysqlDbInfo mysql database information. mysql 数据库信息
type MysqlDbInfo struct {
	Host     string `validate:"required" consul:"host"`     // Host. 地址
	Port     int    `validate:"required" consul:"port"`     // Port 端口号
	Username string `validate:"required" consul:"username"` // Username 用户名
	Password string `consul:"password"`                     // Password 密码
	Database string `validate:"required" consul:"database"` // Database 数据库名
	Type     int    // 数据库类型: 0:mysql , 1:sqlite , 2:mssql
}

func main() {
	conf := consulkv.NewConfig(
		consulkv.WithPrefix("service/servername"),      // consul kv prefix
		consulkv.WithAddress("192.155.1.150:8500"), // consul address
	)
	if err := conf.Init(); err != nil {
		mylog.Error(err)
		return
	}

	var config Config
	consult.AutoLoadConfig(conf, &config) //  自动加载
	fmt.Println(config)

	consult.AutoSetConfig(conf, &config, false) // 执行一次更新
	fmt.Println(config)
}

```

## 更多：
[xxjwxc](https://xxjwxc.github.io/)
[consult](https://github.com/xxjwxc/consult)
[consul](https://github.com/hashicorp/consul)
