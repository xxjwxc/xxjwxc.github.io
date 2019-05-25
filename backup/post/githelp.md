---
# 常用定义
title: "git 使用帮助文档"           # 标题
date: 2019-05-01T16:01:23+08:00    # 创建时间
lastmod: 2019-05-01T16:01:23+08:00 # 最后修改时间
draft: false                       # 是否是草稿？
tags: ["git", "min", "help"]  # 标签
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

## git 命令 
1. 建立一个分支  
   `git branch <项目名字 feature/test>`
2. 然后检查分支是否创建成功  
   `git branch （q,退出）` 
3. 切换到新分支  
    `git checkout <项目名字 feature/test>`
4.  查看当前所有的更改情况  
    `git status`
5. 查看具体的变动  
    `git diff <文件名>`
6. 查看commit历史  
    `git log`
7. 回滚  
    ```
    git log
    
    //如commit 05d1d38601df7d4acd5b09d30d3bab516bf91b0f，回退到该commit
    //一般选取commit号的前6位就可以了
    git reset --hard 05d1d3
    
    ```
8. 将改动提交到新分支上  
    ```
    git add . 
    
    git commit -m "tmp"
    
    git push <origin feature/xxx>
    ```
9. 合并分支 （ezmr）
    ```
    git branch < uat/garencieres >
     git branch < 目标分支>
    git merge <feature/garencieres 自己要合并的分支>
    
    ```
10. 更新分支 
    ```
    git remote update
    ```
11. 删除分支   
    ```
     git branch -d <项目名字 feature/test>
    ```
12. 拉取分支最新的   
    ```
    git pull origin master
    ```