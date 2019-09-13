---
# 常用定义
title: "vue环境配置及vscode调试"           # 标题
date: 2019-09-12T11:48:31+08:00    # 创建时间
lastmod: 2019-09-12T11:48:31+08:00 # 最后修改时间
draft: false                       # 是否是草稿？
tags: ["vue", "工具", "debug"]  # 标签
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

## mac安装 vue开发环境

- 配置脚本在 [vue_install.sh](/image/vue_install.sh)

```sh
#!/bin/bash -v
#set -v 

echo  "vrew 版本."
brew -v 

echo "安装node.js"
brew install nodejs

echo "查看node 版本"
node -v

echo "获取nodejs模块安装目录访问权限 （必须执行）"
sudo chmod -R 777 /usr/local/lib/node_modules/

echo "安装 淘宝镜像 （cnpm）"
npm install -g cnpm --registry=https://registry.npm.taobao.org

echo  "安装webpack"
sudo cnpm install webpack-dev-server -g 
sudo cnpm install webpack -g
sudo cnpm install webpack-dev-server -g 

echo "安装vue脚手架"
sudo cnpm install -g vue-cli

echo "到目的目录"
cd ./src

echo "安装项目依赖"
cnpm install

echo "安装 vue 路由模块vue-router和网络请求模块vue-resource"
cnpm install vue-router vue-resource --save

echo "启动项目：在项目目录中使用,npm run dev 或 cnpm run dev"

echo "报错可能需要执行(npm install 或 npm install -g @vue/cli@latest)"

```

- 详细请见注解

## vscode vue 调试 (chrome 浏览器)

1. 安装chrome 到系统软件目录(必须系统软件目录))

2. vscode 搜索chrome debug插件
![2](/image/vue1.png)

3. 配置debug信息
![3](/image/vue2.png)

 - 配置调试信息
 ![3](/image/vue3.png)
 注意：这里需要配置的url需要与
- demo 端口需要一一映射
![4](/image/vue4.png)


4. 调试开始

- 启动vue项目

```
 npm run dev
```
- 启动 vscode 调试

![5](/image/vue5.jpg)

----------
