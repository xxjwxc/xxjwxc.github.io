---
# 常用定义
title: "日志系统设计"           # 标题
date: 2019-05-25T14:01:23+08:00    # 创建时间
lastmod: 2019-05-25T14:01:23+08:00 # 最后修改时间
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

[代码传送门](https://github.com/xie1xiao1jun/esLog)


- 1、日志主要说明：谁在什么时间,在什么地方,做了什么事情，产生了什么影响，影响的变化因子。

- 2、日志系统主要建设在oplogger基础上。将现有的mysql存储方式改成elasticsearch的存储方式。并且更新了现有字段，使其更优化

- 3、以下为主要设计原理图：

![图片描述](/image/tapd_20332201_base64_1555911551_22.png)

以下为时序图：

![图片描述](/image/tapd_20332201_base64_1555911442_70.png)


- 5、新日志系统的数据格式说明：

根据日志基本形态结合实际需求，列出一下思维导图

![](/image/tapd_personalword_1120122431001000641_base64_1555902612_27.png)

以下归类列出数据列。



![图片描述](/image/tapd_20332201_base64_1558766987_99.png)


说明：

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

- 6、业务逻辑接口说明
 采用接口，或者插件的形式引入具体业务逻辑中。
 以下为接口实现及逻辑：


![图片描述](/image/tapd_20332201_base64_1555911779_3.png)

![图片描述](/image/tapd_20332201_base64_1558790436_67.png)




6、逻辑及代码调用说明：

业务逻辑调用：

``` go
//------ 日志记录 ------
var oploger logerlogic.OpLogerTuple //创建一个三元组日志类型
for _, v := range list {//添加多个日志
	oploger.AddOne(oplogger.EOpType_EOpSTokin,"service", username, sku,"操作补拍", "", oplogger.ELogLevel_EOperate)
}
//发送日志
logerlogic.OnAddLogOplogger(ctx, &oploger)
```


6、逻辑及代码调用说明：

日志写入调用：

```go
eslist := tools.ConvertRe2ESLog(req.Info)
for _, v := range eslist {
	tmp = append(tmp, v)
}

//批量添加
b := es.GetClient().BulkAdd(config.Config.ElasticSearch.Index,
	config.Config.ElasticSearch.Index, "", tmp)
```


日志写入调用：

```go
eslist := tools.ConvertRe2ESLog(req.Info)
for _, v := range eslist {
	tmp = append(tmp, v)
}

//批量添加
b := es.GetClient().BulkAdd(config.Config.ElasticSearch.Index,
		config.Config.ElasticSearch.Index, "", tmp)
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

eslist := tools.Search(term, match, timeCase, req.Page, req.Limit)
```



说明：以接口解耦，具体业务根据不同需求实现接口实现。主要用来对数据分流。

[传送门](https://github.com/xie1xiao1jun/esLog)

