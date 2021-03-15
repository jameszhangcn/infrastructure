#chart museum

chartmuseum --debug --port=30180 --storage=local --storage-local-rootdir=/data/chartmuseum --basic-auth-user=hu --basic-auth-pass=hqhelm --cache-redis-password=mentor --cache=redis --cache-redis-addr=127.0.0.1:30963 --cache-redis-db=0 >2&1 &


Using Redis

Example of using Redis as an external cache store:

chartmuseum --debug --port=8080 \
  --storage="local" \
  --storage-local-rootdir="./chartstorage" \
  --cache="redis" \
  --cache-redis-addr="localhost:6379" \
  --cache-redis-password="" \
  --cache-redis-db=0


3、使用

helm repo add  chartmuseum  http://192.168.56.210:30180 --username hu --password hqhelm --tiller-namespace tiller-world
helm plugin install https://github.com/chartmuseum/helm-push
helm  create  demo

修改完成以后，直接上传
helm push  demo  chartmuseum
helm  install -n demo  chartmuseum/demo   --tiller-namespace  tiller-world  --namespace default



helm3 install testhelm ./ --kubeconfig /nfsroot/workspace/agent-apple/.kube/config 

helm3 delete testhelm  --kubeconfig /nfsroot/workspace/agent-apple/.kube/config

