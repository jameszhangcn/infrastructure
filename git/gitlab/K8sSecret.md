使用kubernetes-plugin插件连接k8s的认证方式
一、使用 rbac授权，token的方式连接k8s
1、rbac授权
Jenkins通过kubernetes-plugin对k8s进行操作，需要在k8s内提前进行rbac授权。为方便管理，我们为其绑定cluster-admin角色。当然也可以进一步缩小使用权限。

#创建serviceaccounts
kubectl create sa jenkins
#对jenkins做cluster-admin绑定
kubectl create clusterrolebinding jenkins --clusterrole cluster-admin --serviceaccount=default:jenkins
2、获取token
kubernetes-plugin与k8s连接时，并不是直接使用serviceaccount，而是通过token。因此我们需要获取serviceaccount:jenkins对应的token。

复制代码
# 1.查看sa
[root@k8s-master updates]# kubectl get sa -n default
NAME      SECRETS   AGE
default   1         116d
jenkins   1         20s
# 2.查看secret
[root@k8s-master updates]# kubectl describe sa jenkins -n default
Name:                jenkins
Namespace:           default
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   jenkins-token-kgxch
Tokens:              jenkins-token-kgxch
Events:              <none>
3.获取token
[root@k8s-master updates]# kubectl describe secrets jenkins-token-kgxch -n default
Name:         jenkins-token-kgxch
Namespace:    default
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: jenkins
              kubernetes.io/service-account.uid: 07d8890d-12cc-11eb-8ca1-000c29824e3f

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  7 bytes
token:         ####这里就是所需的token
复制代码
3.添加认证
获取到的token解密值，需要在Jenkins master中添加为secret text类型的secret，才能被kubernetes-plugin使用。



 

 

 

 4、kubernetes plugin与k8s连接配置


kubernetes地址：为k8s api server地址，通过调用apiserver操作k8s。可通过以下来查看：
[root@k8s-master images]# kubectl cluster-info
Kubernetes master is running at https://192.168.0.211:6443
KubeDNS is running at https://192.168.0.211:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
凭据：kubernetes plugin可以通过key或凭据的方式与k8s进行认证，方便起见，我们采用凭据的方式，使用我们此前创建的secret text凭据，此时我们需要禁用HTTPS证书检查。
kubernetes命令空间：使用默认的default，同时serviceaccount也在此空间内。
点击连接测试，可以看到k8s已经连接成功

 二、使用证书的方式连接k8s
1、通过解码获取kubectl使用的admin证书
查看 /root/.kube/config文件，文件中有三个值 certificate-authority-data 、client-certificate-data 、 client-key-data 

解码它们获得证书 ，注意将上面的值替换称自己的一大长传字符串

echo certificate-authority-data | base64 -d > ca.crt
echo client-certificate-data | base64 -d > client.crt
echo client-key-data | base64 -d > client.key
根据这三个文件生成一个PKCS12格式的客户端证书文件

openssl pkcs12 -export -out cert.pfx -inkey client.key -in client.crt -certfile ca.crt
注意生成证书的时候，一定要填写密码，后面会用到



 

 2、添加认证
将生成的  cert.pfx  上传到凭证



 

 3、kubernetes plugin与k8s连接配置
将ca.crt中的内容填写到 Kubernetes server certificate key 字段



 

 完成后点击测试连接查看是否成功