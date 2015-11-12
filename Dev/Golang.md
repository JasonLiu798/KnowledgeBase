#Golang
---
#setup
##APT安装
sudo apt-get install golang
出错尝试
sudo add-apt-repository ppa:gophers/go
sudo apt-get update
sudo apt-get install golang-stable

##源码安装
sudo apt-get install bison ed gawk gcc libc6-dev make
sudo apt-get install python-setuptools
sudo apt-get install python-dev
sudo apt-get install build-essential
sudo apt-get install mercurial
cd ~/
###download offical
hg clone -r release https://go.googlecode.com/hg/ go
###download
[golang中国/下载](http://www.golangtc.com/download)
###ENV
export GOROOT=$HOME/go
export GOBIN=$GOROOT/bin
export PATH=$GOBIN:$PATH
export GOPATH=/opt/project/go

export GOARCH=386
export GOOS=linux

cd $GOROOT/src
./all.bash



##helloworld
package main
import "fmt"
func main() {
    fmt.Printf("Hello World!\n")
}

user> go run hello.go

---
#process

##spawn
go exec.Command()来Spawn进程

    lsCmd := exec.Command("bash", "-c", "ls -a -l -h")
    lsOut, err := lsCmd.Output()
    if err != nil {
        panic(err)
    }
    fmt.Println("> ls -a -l -h")
    fmt.Println(string(lsOut))

##执行(Exec)外部程序
execErr := syscall.Exec(binary, args, env)


##信号
import os/signal
siganl.Notify()
signal.Stop()


---
#
[golang对共享内存的操作](http://studygolang.com/articles/743)








