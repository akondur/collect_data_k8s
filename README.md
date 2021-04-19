# collect_data_k8s

A repository which helps provide a script to collect data from a K8S cluster which runs the Splunk Operator for K8S. It involves collecting data via kubectl commands, splunk data via diag etc..

**NOTE of caution, the script**
- Collects extensive data on your K8S cluster. If there is any data you'd like to keep private please avoid using the script(modify it as per your needs)
- Generates splunk diag on all of the Splunk Instances running inside of Splunk Enterprise CR pods deployed by the operator. The diag generated by the script on the splunk instance gets deleted after extraction.

If any of the above is not desired, please resort to collecting data manually.

**Requirements to run the script**

- Kubeconfig context set to the cluster running the Splunk Operator for Kubernetes
- Access to kubectl commands to get data
- Root access on the host file system to create/delete directories(atleast within the directory where you want to run this script and store logs)
- Enough space to collect data in a destination folder

**Script run instructions**

- On your terminal, run `git clone git@github.com:akondur/collect_data_k8s.git` (make sure ssh token is setup, if using https grab the https clone link from `https://github.com/akondur/collect_data_k8s`)
- Run `cd collect_data_k8s`
- Run `chmod 755 *`
- Run the script using the following command - `sh collect_data.sh -d <is_diags_required> -f <desination_folder> -a <avoid_describe_option>`. There are three options which are configurable through the script:
    - The `-d` or `--diag` option which determines whether diags will be collected. This option is `mandatory`(use only `true` or `false`) failing which the script errors out.
    - The `-f` or `--folder` option to specify a `<destination folder>`. This option is `not mandatory`. The script allows you to store the data collected in two different ways:
        - If the `-f` or `--folder` option is not used, a timestamped folder `tmp-<timestamp>` is created in the present working directory where the data will be written to. 
            ```
            Eg. sh collect_data.sh -d true
            ```                
        - If the `-f` or `--folder` option is used with valid full path, a timestamped folder `tmp-<timestamp>` is created inside tthe full path where the data will be written to. Note: If the folder provided doesn't exist it is created if the preceeding path to it exists i.e in the example below if `/Users/akondur` is present, `/collect` is created if it doesn't exist or ignored if it exists. But if the preceeding path `/Users/akondur` doesn't exist the script behavior is undocumented.
            ```    
            Eg. sh collect_data.sh -d true -f /Users/akondur/collect/
            ```
       Please make sure you have enough space in the target folders in either case(for reference look at performance requirements section).
    - The `-a` option to specify whether you want to avoid `kubectl describe` commands. This option is `not mandatory`. There is an issue in K8S with creating too many clients for describe commands(https://github.com/kubernetes/kubernetes/issues/91913). In my testing these messages have not caused any issues. To avoid the warning messages as well to protect your network bandwidth if limited you can set the `-a` option to true.
            ```    
            Eg. sh collect_data.sh -f /Users/akondur/collect/ -a true
            ```
            Example of a warning message from the K8S cluster:

            ```
            W0419 14:46:10.239590   21927 exec.go:203] constructing many client instances from the same exec auth config can cause performance problems during cert rotation and can exhaust available network connections; 1478 clients constructed calling "aws-iam-authenticator"
            ```

- Wait till you see the message `All data requried collected under folder <destination_folder>`

**Example script run output**
```
bash#sh collect_data.sh -d "true"
Starting to collect data with diag true in folder /Users/akondur/Desktop/operator_training/Data_collection_debug/collect_data_k8s/tmp-2021-04-19-10-37 

Setting up directories 

Done setting up directories 

Started collecting logs and diags

Done collecting logs and diags

Started collecting cluster info

Done collecting cluster info

Started collecting kubectl get command outputs

Done collecting kubectl get command outputs

Started collecting kubectl describe command outputs

Done collecting kubectl describe command outputs 

All data requried collected under folder /Users/akondur/Desktop/operator_training/Data_collection_debug/collect_data_k8s/tmp-2021-04-19-10-37
```

**Destination folder breakdown**

**tmp-<ts>/k8s_data/get** - Contains outputs of kubectl get commands for K8S resources in the cluster

**tmp-<ts>/k8s_data/describe** - Contains outputs of kubectl describe commands for K8S resources in the cluster

**tmp-<ts>/pods_data/diags** - Contains diags from all Splunk Instances running inside of Splunk Enterprise CR pods deployed by the operator. 

**tmp-<ts>/pod_data/logs** - Contains logs from all Splunk Enterprise CR pods deployed by the operator and the operator pod itself. 

Note: All logs are appropriately named with proper prefixes. The folder `k8s_data` contains outputs of kubectl get and describe commands for multiple K8S resources. The folder `pods_data` contains logs for all pods in the K8S namespace and also diags from all Splunk pods if requested.

**Performance data**

On a K8S cluster with a **SHC(3 search heads, 1 deployer), IDXC(3 indexers, 1 cluster master), 1 Standalone, 1 License master** as such:

```
kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
splunk-default-monitoring-console-0   1/1     Running   0          17m
splunk-example-license-master-0       1/1     Running   0          18m
splunk-operator-cb8d66765-tl6z2       1/1     Running   0          6h6m
splunk-test-cluster-master-0          1/1     Running   0          19m
splunk-test-deployer-0                1/1     Running   0          6h3m
splunk-test-indexer-0                 1/1     Running   0          17m
splunk-test-indexer-1                 1/1     Running   0          17m
splunk-test-indexer-2                 1/1     Running   0          17m
splunk-test-search-head-0             1/1     Running   0          6h3m
splunk-test-search-head-1             1/1     Running   0          6h3m
splunk-test-search-head-2             1/1     Running   0          6h3m
splunk-test2-standalone-0             1/1     Running   0          6h5m
```

The script has the following performance:

```
Time taken - 6 mins 40 seconds
Memory - 774.4 MB
```

**Contact Info**
Email `akondur@splunk.com` for any queries.