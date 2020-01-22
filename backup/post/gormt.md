---
# 常用定义
title: "gormt mysql数据库转换工具"           # 标题
date: 2020-01-25T10:01:23+08:00    # 创建时间
lastmod: 2020-01-25T10:01:23+08:00 # 最后修改时间
draft: false                       # 是否是草稿？
tags: ["golang", "gorm", "工具"]  # 标签
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

# [gormt](https://github.com/xxjwxc/gormt)


### 一款 mysql 数据库转 struct 工具

- 可以将mysql数据库自动生成 golang 结构
- [自动生成快捷操作函数](https://github.com/xxjwxc/gormt/blob/master/data/view/genfunc/genfunc_test.go)
- [支持索引,外键](https://github.com/xxjwxc/gormt/tree/master/doc/export_cn.md)
- 带大驼峰命名规则
- 带json标签

## 交互界面模式

![show](/image/gormt/ui_cn.gif)

```
./gormt -g=true
```

## 命令行模式

![show](/image/gormt/out.gif)
```
./gormt -g=false
```

--------

## 1. 通过当前目录config.toml文件配置默认配置项
```
out_dir : "."  # 输出目录
singular_table : false  # 表名复数,是否大驼峰构建 参考:gorm.SingularTable
simple : false #简单输出
is_out_sql : false # 是否输出 sql 原信息
is_out_func : true # 是否输出 快捷函数
is_json_tag : false #是否打json标记
is_foreign_key : true #是否导出外键关联
mysql_info :
    host : "127.0.0.1"
    port : 3306
    username : "root"
    password : "qwer"
    database : "oauth_db"

```
## 2. 可以使用命令行工具更新配置项
```
./gormt -H=127.0.0.1 -d=oauth_db -p=qwer -u=root --port=3306
```
## 3. 查看帮助
```
./gormt -h

-------------------------------------------------------
base on gorm tools for mysql database to golang struct

Usage:
  main [flags]

Flags:
  -d, --database string   数据库名
  -h, --help              help for main
  -H, --host string       数据库地址.(注意-H为大写)
  -o, --outdir string     输出目录
  -p, --password string   密码.
      --port int          端口号 (default 3306)
  -s, --singular          是否禁用表名复数
  -u, --user string       用户名.
  
```

## 4. 支持gorm 相关属性 
   
- 数据库表,列字段注释支持
- singular_table 表名复数(大驼峰)
- json tag json标签输出
- gorm.Model 基本模型   [支持gorm.Model模式导出>>>](https://github.com/xxjwxc/gormt/tree/master/doc/export_cn.md)
- PRIMARY_KEY	将列指定为主键
- UNIQUE	将列指定为唯一
- NOT NULL	将列指定为非 NULL
- INDEX	创建具有或不带名称的索引, 如果多个索引同名则创建复合索引
- UNIQUE_INDEX	和 INDEX 类似，只不过创建的是唯一索引
- 支持外键相关属性 [简单带外键模式导出>>>](https://github.com/xxjwxc/gormt/tree/master/doc/export_cn.md)
- 支持函数导出(包括:外键，关联体，索引关...)[简单函数导出示例>>>](https://github.com/xxjwxc/gormt/blob/master/data/view/genfunc/genfunc_test.go)

## 5. 示例展示


###### --->导出结果示例

- 参数:singular_table = false simple = false isJsonTag = true

```
//	用户信息
type UserAccountTbl struct {
	ID          int       `gorm:"primary_key;column:id;type:int(11);not null" json:"-"`                                                   //
	Account     string    `gorm:"unique;column:account;type:varchar(64);not null" json:"account"`                                         //
	Password    string    `gorm:"column:password;type:varchar(64);not null" json:"password"`                                              //
	AccountType int       `gorm:"column:account_type;type:int(11);not null" json:"account_type"`                                          //	帐号类型:0手机号，1邮件
	AppKey      string    `json:"app_key" gorm:"unique_index:UNIQ_5696AD037D3656A4;column:app_key;type:varchar(255);not null"`            //	authbucket_oauth2_client表的id
	UserInfoID  int       `gorm:"unique_index:UNIQ_5696AD037D3656A4;index;column:user_info_id;type:int(11);not null" json:"user_info_id"` //
	RegTime     time.Time `gorm:"column:reg_time;type:datetime" json:"reg_time"`                                                          //
	RegIP       string    `gorm:"column:reg_ip;type:varchar(15)" json:"reg_ip"`                                                           //
	BundleID    string    `json:"bundle_id" gorm:"column:bundle_id;type:varchar(255)"`                                                    //
	Describ     string    `gorm:"column:describ;type:varchar(255)" json:"describ"`                                                        //
}
```

- 参数:singular_table = false simple = true isJsonTag = false

###### --->导出结果

```
//	用户信息
type UserAccountTbl struct {
	ID          int       `gorm:"primary_key"` //
	Account     string    `gorm:"unique"`      //
	Password    string    //
	AccountType int       //	帐号类型:0手机号，1邮件
	AppKey      string    `gorm:"unique_index:UNIQ_5696AD037D3656A4"`       //	authbucket_oauth2_client表的id
	UserInfoID  int       `gorm:"unique_index:UNIQ_5696AD037D3656A4;index"` //
	RegTime     time.Time //
	RegIP       string    //
	BundleID    string    //
	Describ     string    //
}
```

### [更多>>>](https://github.com/xxjwxc/gormt/tree/master/doc/export_cn.md)

## 6. 支持函数导出(导出函数只是 gorm 的辅助类函数，完全兼容 gorm 相关函数集)

```
// FetchByPrimaryKey primay or index 获取唯一内容
func (obj *_UserAccountTblMgr) FetchByPrimaryKey(ID int) (result UserAccountTbl, err error) {
	err = obj.DB.Table(obj.GetTableName()).Where("id = ?", ID).Find(&result).Error
	if err == nil && obj.isRelated {
		{
			var info UserInfoTbl // 用户信息
			err = obj.DB.Table("user_info_tbl").Where("id = ?", result.UserInfoTblID).Find(&info).Error
			if err != nil {
				return
			}
			result.UserInfoTbl = info
		}
	}

	return
}

```

### [更多>>>](https://github.com/xxjwxc/gormt/tree/master/doc/func_cn.md)

### [函数调用示例>>>](https://github.com/xxjwxc/gormt/blob/master/data/view/genfunc/genfunc_test.go)

## 7. 构建
```
make windows
make linux
make mac
```
or

```
go generate
```

## 8. 下一步计划

- 更新，删除功能函数添加
- 优化

## 9. 提供一个windows 可视化工具

![图片描述](/image/gormt/1.png)

![图片描述](/image/gormt/2.jpg)

![图片描述](/image/gormt/3.jpg)

![图片描述](/image/gormt/4.jpg)

[下载地址](https://github.com/xxjwxc/gormt/releases/download/v1.0.0.1/v1.0.zip)


- ###### [传送门](https://github.com/xxjwxc/gormt)

