---
# 常用定义
title: "hanlp golang接口"           # 标题
date: 2021-03-27T10:01:23+08:00    # 创建时间
lastmod: 2021-03-27T10:01:23+08:00 # 最后修改时间
draft: false                       # 是否是草稿？
tags: ["golang", "hanlp", "api"]  # 标签
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

## [GoHanlp](https://github.com/xxjwxc/gohanlp)

### 前言

[Hanlp](https://github.com/hankcs/HanLP) 是基于PyTorch和TensorFlow 2.x的面向研究人员和公司的多语言NLP库，用于在学术界和行业中推广最先进的深度学习技术。HanLP从一开始就被设计为高效，用户友好和可扩展的。它带有针对各种人类语言的预训练模型，包括英语，中文和许多其他语言。
[GoHanlp](https://github.com/xxjwxc/gohanlp) 是Hanlp的api接口golang实现版本

## 使用方式

### 安装 [GoHanlp](https://github.com/xxjwxc/gohanlp)
```
go get -u github.com/xxjwxc/gohanlp@master
```
#### 使用

#### 申请auth认证

https://bbs.hanlp.com/t/hanlp2-1-restful-api/53

- 不认证 `hanlp.WithAuth("")` 请填空

#### 文本形式

```
package main

import (
	"fmt"
	"github.com/xxjwxc/gohanlp/hanlp"
)

func main() {
	client := hanlp.HanLPClient(hanlp.WithAuth("")) // 你申请到的auth,auth不填则匿名
	s, _ := client.Parse("2021年HanLPv2.1为生产环境带来次世代最先进的多语种NLP技术。阿婆主来到北京立方庭参观自然语义科技公司。",
		hanlp.WithLanguage("zh"))
	fmt.Println(s)
}
```

#### 对象形式

```
package main

import (
	"fmt"

	"github.com/xxjwxc/gohanlp/hanlp"
)

func main() {
	client := hanlp.HanLPClient(hanlp.WithAuth("")) // 你申请到的auth,auth不填则匿名
	resp, _ := client.ParseObj("2021年HanLPv2.1为生产环境带来次世代最先进的多语种NLP技术。阿婆主来到北京立方庭参观自然语义科技公司。",hanlp.WithLanguage("zh"))
	fmt.Println(resp)
}
```

#### 接口说明

- HanLPClient 中 option 是变量参数，每次调用都会带上
- Parse... 中option 是零时参数，只在本次调用有效


#### 更多调用API 请查看
[options](https://github.com/xxjwxc/gohanlp/blob/main/hanlp/option.go)

## 更多：
[xxjwxc](https://xxjwxc.github.io/)
[GoHanlp](https://github.com/xxjwxc/gohanlp)
[options](https://github.com/xxjwxc/gohanlp/blob/main/hanlp/option.go)
