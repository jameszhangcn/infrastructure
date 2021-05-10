#git hub

## create repository

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm fetch bitnami/postgresql
helm3 install my-psql . --debug

```

```
NOTES:
** Please be patient while the chart is being deployed **

PostgreSQL can be accessed via port 5432 on the following DNS name from within your cluster:

    my-psql-postgresql.default.svc.cluster.local - Read/Write connection

To get the password for "postgres" run:

    export POSTGRES_PASSWORD=$(kubectl get secret --namespace default my-psql-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)

To connect to your database run the following command:

    kubectl run my-psql-postgresql-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/postgresql:11.11.0-debian-10-r86 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host my-psql-postgresql -U postgres -d postgres -p 5432

```