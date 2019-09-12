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
