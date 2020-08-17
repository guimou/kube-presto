# TPC-DS workload with Presto on OpenShift

## Deploy a Presto Cluster

Presto operator

## (Optional) Create a Presto CLI container image

From the **docker** folder, edit the file `build-cli.sh` to change the repo name and optionally the version you want to buid, then run:

```bash
./build-cli.sh
```

## Create TPC-DS Data

### Data bucket

A data bucket must have been created during the Presto benchmark installation. This is the bucketname that must be referenced in the Jobs files.

### Logs

All the logs will be writtent to a shared volume for easy retrieval. Create this volume with:

```bash
oc apply -f 00_pvc_presto-data-share.yaml
```

### Presto CLI

If you want an ever running Presto CLI env, you can use the provided Deployment Config:

```bash
oc apply -f 01_dc_presto-cli.yaml
```

### Data creation

Create the different Data sets at different scale directly with the Jobs in the **jobs** folder:

```bash
oc apply -f 01_tpcds_create_table_sf1.yaml
```

Then proceed in the same way for sf10, sf100, sf1000.

### Credits

Original code by Yifeng Jiang available [here](https://github.com/uprush/kube-presto/tree/master/benchmark).
