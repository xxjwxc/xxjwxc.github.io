---
# 常用定义
title: "golang gRPC 和 HTTP 共用端口"           # 标题
date: 2021-02-24T10:01:23+08:00    # 创建时间
lastmod: 2021-02-24T10:01:23+08:00 # 最后修改时间
draft: false                       # 是否是草稿？
tags: ["golang", "cmux", "端口复用"]  # 标签
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

### 前言

接口需要提供给其他业务组访问，但是 RPC 协议不同无法内调，对方问能否走 HTTP 接口
有时候，我们服务都需要同时支持grpc跟http(restful)协议,但是我们又不想多端口开放

### 原理

原理主要是通过共用`listener` 模式 通过`Accept()`入口来区分协议内容


### golang 实现 

```go
package main

import (
	"github.com/soheilhy/cmux"
)

func Run(){
	// 起服务
	// Create the main listener.
	l, err := net.Listen("tcp", ":23456")
	if err != nil {
		log.Fatal(err)
	}

	// Create a cmux.
	m := cmux.New(l)

	// First grpc, then HTTP, and otherwise Go RPC/TCP.
	grpcL := m.MatchWithWriters(cmux.HTTP2MatchHeaderFieldSendSettings("content-type", "application/grpc"))
	go grpcS.Serve(grpcL)// Use the muxed listeners for your servers.

	httpL := m.Match(cmux.HTTP1Fast())
	httpS := &http.Server{
		Handler: &helloHTTP1Handler{},
	}
	go httpS.Serve(httpL)

	// Start serving!
	m.Serve()	
}
```

#### gin+grpc 实现
```go
package main

import (
	"github.com/soheilhy/cmux"
)

func Run(){
	// 起服务
	l, err := net.Listen("tcp", ":23456")

	m := cmux.New(l)

	// grpc
	grpcL := m.MatchWithWriters(cmux.HTTP2MatchHeaderFieldSendSettings("content-type", "application/grpc"))
	grpcS := grpc.NewServer()
	grpchello.RegisterGreeterServer(grpcS, &server{})
	go grpcS.Serve(grpcL)
	
	// http
	router := gin.Default()
	go func (){
		httpL := m.Match(cmux.HTTP1Fast())
		router.RunListener(httpL)
	}()


	// Start serving!
	m.Serve()	
}
```

[goplugins](https://github.com/gmsec/goplugins/blob/master/plugin/gin.go)

## 更多：
[xxjwxc](https://xxjwxc.github.io/)
[goplugins](https://github.com/gmsec/goplugins)
[gmsec](https://github.com/gmsec)