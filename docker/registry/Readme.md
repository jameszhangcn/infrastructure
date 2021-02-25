
# install the docker registry

```
helm install ./ --name my-registry --debug
```

```
helm fetch stable/docker-registry
```

#use http to connect the :5000

# List all the docker images

```
curl -X GET http://192.168.56.210:30500/v2/_catalog  
{"repositories":["gowebdemo"]}
```

```
root@k8s:~# curl -X GET http://192.168.56.210:30500/v2/gowebdemo/tags/list  
{"name":"gowebdemo","tags":["v1"]}
```


```  
操作步骤
1. 通过环境变量修改默认配置，允许删除
2. 获取image的sha值
3. 进入registry容器中，执行垃圾回收
4. 删除残留目录
#环境变量 REGISTRY_STORAGE_DELETE_ENABLED=true 用于覆盖默认设置
docker run -d -v /opt/registry:/var/lib/registry -e REGISTRY_STORAGE_DELETE_ENABLED=true -p 5000:5000 --restart=always --name registry registry:2

#声明要删除的镜像名称
image=...
#获取sha
sha=`ls /opt/registry/docker/registry/v2/repositories/$image/_manifests/revisions/sha256`
#删除 需替换registryurl
curl -XDELETE http://<registryurl>/v2/$image/manifests/sha256:$sha
#垃圾回收
docker exec -it registry sh
registry garbage-collect /etc/docker/registry/config.yml
exit
#删除残留目录
rm -rf /opt/registry/docker/registry/v2/repositories/$image
```