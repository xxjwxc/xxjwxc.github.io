---
# 常用定义
title: "golang chunck 服务器长连接"           # 标题
date: 2020-12-25T10:01:23+08:00    # 创建时间
lastmod: 2020-12-25T10:01:23+08:00 # 最后修改时间
draft: false                       # 是否是草稿？
tags: ["golang", "chunck", "工具"]  # 标签
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

### http 协议的chunck概念

有时候，Web服务器生成HTTP Response是无法在Header就确定消息大小的，这时一般来说服务器将不会提供Content-Length的头信息，而采用Chunked编码动态的提供body内容的长度。
进行Chunked编码传输的HTTP Response会在消息头部设置：

`Transfer-Encoding: chunked`

表示Content Body将用Chunked编码传输内容。

Chunked编码使用若干个Chunk串连而成，由一个标明长度为0的chunk标示结束。每个Chunk分为头部和正文两部分，头部内容指定下一段正文的字符总数（十六进制的数字）和数量单位（一般不写），正文部分就是指定长度的实际内容，两部分之间用回车换行(CRLF)隔开。在最后一个长度为0的Chunk中的内容是称为footer的内容，是一些附加的Header信息

### golang `net/http` 实现

```go
package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"time"

	"github.com/xxjwxc/public/tools"
)

// NlpResp 返回信息
type NlpResp struct {
	// bool state = 1; // 状态
	MatchID    int      `json:"matchId"`
	Audio      string   `json:"audio"`
	Hai        string   `json:"hai"`
	Text       string   ` json:"text"`
	RemainText []string `json:"remainText"`
}

func httpServer() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		flusher, ok := w.(http.Flusher)
		if !ok {
			panic("expected http.ResponseWriter to be an http.Flusher")
		}
		w.Header().Set("X-Content-Type-Options", "nosniff")
		for i := 1; i <= 20; i++ {
			tmp := NlpResp{
				MatchID: i,
				Audio:   "aaaaaaaaaaaaaaaaaaaaa",
				Hai:     "hhhhhhhhhhhhhhhhhhhh",
				Text:    "test",
			}
			fmt.Fprintf(w, tools.GetJSONStr(tmp, false)+"\n")
			flusher.Flush() // Trigger "chunked" encoding and send a chunk...
			time.Sleep(1 * time.Second)
		}
	})

	log.Print("Listening on localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func httpClien() {
	resp, err := http.Get("http://localhost:8080")
	if err != nil {
		// handle error
	}

	defer resp.Body.Close()

	// chunkedReader := httputil.NewChunkedReader(resp.Body)

	buf := make([]byte, 40960)
	for {
		n, err := resp.Body.Read(buf)
		fmt.Println(n, err)
		if n != 0 || err != io.EOF { // simplified
			fmt.Println(string(buf[:n]))
		}
		time.Sleep(1 * time.Second)
	}
}

func main() {
	go httpServer()
	go httpClien()

	time.Sleep(100 * time.Second)
}
```

#### gin 实现

```
package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/xxjwxc/public/tools"
)

// NlpResp 返回信息
type NlpResp struct {
	// bool state = 1; // 状态
	MatchID    int      `json:"matchId"`
	Audio      string   `json:"audio"`
	Hai        string   `json:"hai"`
	Text       string   ` json:"text"`
	RemainText []string `json:"remainText"`
}

func httpServer() {
	r := gin.Default()
	// your working routes
	r.GET("/", func(c *gin.Context) {
		w := c.Writer
		flusher, ok := w.(http.Flusher)
		if !ok {
			panic("expected http.ResponseWriter to be an http.Flusher")
		}
		w.Header().Set("X-Content-Type-Options", "nosniff")
		for i := 1; i <= 20; i++ {
			tmp := NlpResp{
				MatchID: i,
				Audio:   "aaaaaaaaaaaaaaaaaaaaa",
				Hai:     "hhhhhhhhhhhhhhhhhhhh",
				Text:    "test",
			}
			fmt.Fprintf(w, tools.GetJSONStr(tmp, false)+"\n")
			flusher.Flush() // Trigger "chunked" encoding and send a chunk...
			time.Sleep(1 * time.Second)
		}
	})

	log.Print("Listening on localhost:8080")
	r.Run(":8080")
}

func httpClien() {
	resp, err := http.Get("http://localhost:8080")
	if err != nil {
		// handle error
	}

	defer resp.Body.Close()

	// chunkedReader := httputil.NewChunkedReader(resp.Body)

	buf := make([]byte, 40960)
	for {
		n, err := resp.Body.Read(buf)
		fmt.Println(n, err)
		if n != 0 || err != io.EOF { // simplified
			fmt.Println(string(buf[:n]))
		}
		time.Sleep(1 * time.Second)
	}
}

func main() {
	go httpServer()
	go httpClien()

	time.Sleep(100 * time.Second)
}

```

## 更多：
[xxjwxc](https://xxjwxc.github.io/)