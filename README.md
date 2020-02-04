# Spark on openshift

## Build spark image

```bash
oc create is spark
oc apply -f spark-bc.yaml
oc start-build spark --from-dir=. --follow
```

## Create account and permissions for spark

```bash
oc apply -f spark-role.yaml
oc create serviceaccount spark
oc create rolebinding spark --role=spark --serviceaccount=icteam:spark
```

## Discover kubernetes master
```bash
kubectl -n icteam cluster-info
```

## Submit spark job

```bash
/usr/local/Cellar/apache-spark/2.4.4/libexec/bin/spark-submit \
    --master k8s://https://api.ca-central-1.starter.openshift-online.com:6443  \
    --deploy-mode cluster \
    --name demo \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.kubernetes.container.image=image-registry.openshift-image-registry.svc:5000/icteam/spark \
    --conf spark.executor.instances=1 \
    --conf spark.kubernetes.namespace=icteam \
    --conf spark.kubernetes.driver.limit.cores=1000m \
    --conf spark.kubernetes.executor.request.cores=1000m \
    --conf spark.kubernetes.executor.limit.cores=1000m \
    --conf spark.driver.memory=512m \
    --conf spark.executor.memory=512m \
    --conf spark.kubernetes.allocation.batch.size=1 \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.kubernetes.container.image.pullPolicy=Always \
    --conf spark.kubernetes.driver.label.app=demo \
    --conf spark.kubernetes.executor.label.app=demo \
    local:////opt/spark-3.0.0-preview2/examples/jars/spark-examples_2.12-3.0.0-preview2.jar
```

```bash
/usr/local/Cellar/apache-spark/2.4.4/libexec/bin/spark-submit \
    --master k8s://https://api.ca-central-1.starter.openshift-online.com:6443  \
    --deploy-mode cluster \
    --name demo \
    --class be.icteam.demo.App \
    --conf spark.kubernetes.container.image=image-registry.openshift-image-registry.svc:5000/icteam/spark \
    --conf spark.executor.instances=1 \
    --conf spark.kubernetes.namespace=icteam \
    --conf spark.kubernetes.driver.limit.cores=1000m \
    --conf spark.kubernetes.executor.request.cores=1000m \
    --conf spark.kubernetes.executor.limit.cores=1000m \
    --conf spark.driver.memory=512m \
    --conf spark.executor.memory=512m \
    --conf spark.kubernetes.allocation.batch.size=1 \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.kubernetes.container.image.pullPolicy=Always \
    --conf spark.kubernetes.driver.label.app=demo \
    --conf spark.kubernetes.executor.label.app=demo \
    local:////opt/spark-3.0.0-preview2/examples/jars/demo-1.0-SNAPSHOT.jar
```

```bash
oc delete all -l app=demo
```

