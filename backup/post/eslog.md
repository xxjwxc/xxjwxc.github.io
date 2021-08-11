---
# 常用定义
title: "golang elasticsearch 操作函数"           # 标题
date: 2021-08-11T14:01:23+08:00    # 创建时间
lastmod: 2021-08-11T14:01:23+08:00 # 最后修改时间
draft: false                       # 是否是草稿？
tags: ["golang", "日志", "log"]  # 标签
categories: ["设计"]              # 分类
author: "xiexiaojun"                  # 作者

weight: 1

# 用户自定义
# 你可以选择 关闭(false) 或者 打开(true) 以下选项
comment: true   # 评论
toc: true       # 文章目录
reward: true	 # 打赏
mathjax: true    # 打开 mathjax

---


#日志系统说明
先来传送门:

[代码传送门](https://github.com/xxjwxc/esLog)


- 1、日志主要说明：谁在什么时间,在什么地方,做了什么事情，产生了什么影响，影响的变化因子。

- 2、日志系统主要建设在oplogger基础上。将现有的mysql存储方式改成elasticsearch的存储方式。并且更新了现有字段，使其更优化

- 3、以下为主要设计原理图：


说明：

1. trace_id ：  用来追踪一个请求的全服务调用流向
2. 应用/服务的唯一标识：   用来确定日志产生的应用服务器的唯一标识(可以细分)
3. 业务项的唯一标识：  用来确定逻辑段的唯一标识，如orderid，sku，stokin_code 等
4. 时间序列表：  用来记录日志的变化时间序，及日志创建的时间点
5. 事件序列、描述：  具体描述一件事情；如打包调试信息，封箱错误信息，拆包裹业务信息
6. 变化值序列：  描述事件内部的不同变化值
7. 备注：  用于一些说明
8. 预留字段：  用来扩展日志系统业务能力
9. caller：  日志产生的当前文件名及行号等信息
10. user_id,user_name ：添加操作人记录



6、golang elasticsearch 查询封装：

- 初始化 
  
```go 
import (
	"github.com/xxjwxc/esLog/view/es"
)
	client,_ := New(WithIndexName("test_log"), WithAddrs("http://192.168.198.17:9200/"))
	//精确搜索
	term := make(map[string]interface{})
	term["topic"] = "topic"
	term["etype"] = oplogger.EOpType_EOpGunbuster
	term["user_name"] = "username"
	term["ekey"] = "iddd-1"
	term["elevel"] = oplogger.ELogLevel_EOperate
	//模糊匹配
	match := make(map[string]interface{})
	match["desc"] = "desc"
	match["attach"] = "attach"

	// 时间范围
	timeCase := make(map[string]CaseSection)
	timeCase["creat_time"] = CaseSection{
		Min: time.Now().AddDate(0, 0, -1),
		Max: time.Now(),
	}

	//构造搜索器
	var que EsQuery
	que.OnPages(0, 10).OnTerm(term).OnMatch(match).OnRangeTime(timeCase)

	// 答应查询字符串 
	data1, _ := json.Marshal(que.OnSource())
	fmt.Println(string(data1))

	// 查询结果
	client, _ := New(WithIndexName(Index), WithAddrs(url))
	var eslog []ESLog
	client.WithOption(WithIndexName(Index), WithTypeName(Index)).Search(que.OnSource(), func(e []byte) error {
		var tmp ESLog
		json.Unmarshal(e, &tmp)
		eslog = append(eslog, tmp)
		return nil
	})

	fmt.Println(eslog)// 答应结果
```

6、逻辑及代码调用说明：

日志写入调用：

```go
//批量添加
client.BulkAdd(list)
```


日志写入调用：

```go
//批量添加
client.Add(info)
```


日志搜索：

```go

//精确搜索
term := make(map[string]interface{})
...
//模糊匹配
match := make(map[string]interface{})
...
//时间段搜索
timeCase := make(map[string]es.CaseSection)
...


// tools 搜索
eslist := tools.Search(term, match, timeCase, req.Page, req.Limit)

```

说明：以接口解耦，具体业务根据不同需求实现接口实现。主要用来对数据分流。

[传送门](https://github.com/xxjwxc/esLog)

[设计思想](https://xxjwxc.github.io/post/loglistdef/)