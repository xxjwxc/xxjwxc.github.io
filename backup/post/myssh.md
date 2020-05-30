---
# 常用定义
title: "golang ssh 远程终端控制"           # 标题
date: 2020-05-16T23:01:23+08:00    # 创建时间
lastmod: 2020-05-16T23:01:23+08:00 # 最后修改时间
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
# golang ssh 远程命令终端支持
## 一个封装，支持自动补全

## 代码：
```go
package main


import (
	"fmt"
	"time"
	_ "gmsec/internal/routers" // debug模式需要添加[mod]/routers 注册注解路由
	"github.com/xxjwxc/public/myssh"
)

func main() {
	c, err := myssh.New("127.0.0.1", "ubuntu", "123456", 22)
	if err != nil {
		fmt.Println("err", err)
	}

	output, err := c.Run("free -h")
	fmt.Printf("%v\n%v", output, err) // 返回字符串

	time.Sleep(1 * time.Second)

	// c.RunTerminal("top") 交互式

	// time.Sleep(1 * time.Second)

	c.Terminal() // 进入
}
```

# 详细代码 ==> [myssh](https://github.com/xxjwxc/public/blob/master/myssh/myssh.go)

# [感谢您的点星支持](https://github.com/xxjwxc/public/)
