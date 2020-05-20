time3=$(date "+%Y-%m-%d %H:%M:%S")
echo $time3
hugo
cp -rf ~/work/xxjbolg/public/* ~/work/workspace/github/xxjwxc/xxjwxc.github.io/
cp -rf ~/work/xxjbolg/content/post ~/work/workspace/github/xxjwxc/xxjwxc.github.io/backup
cd ~/work/workspace/github/xxjwxc/xxjwxc.github.io/
git add *
git commit -m "new update on $time3"
git push origin -f master
cd ~/work/xxjbolg/
echo "发布成功"