# collect_data_k8s

A repository which helps provide a script to collect data from a K8S cluster which runs the Splunk Operator for K8S. It involves collecting data via kubectl commands, splunk data via diag etc..

**NOTE of caution, the script**
- Collects extensive data on your K8S cluster. If there is any data you'd like to keep private please avoid using the script(modify it as per your needs)
- Generates splunk diag on all of the Splunk Instances running inside of Splunk Enterprise CR pods deployed by the operator. 

If any of the above is not desired, please resort to collecting data manually.

**Requirements to run the script**

- Kubeconfig context set to the cluster running the Splunk Operator for Kubernetes
- Access to kubectl commands to get data
- Root access on the host file system to create/delete directories(atleast within the directory where you want to run this script and store logs)
- Enough space to collect data in the folder

**Script run instructions**

- Make sure you meet requirements above.
- Get access to a terminal and find a folder on your machine where there is enough space to collect data. Move the cursor context to that folder(In linux, macos "cd" to that folder)
- "git clone git@github.com:akondur/collect_data_k8s.git" (make sure ssh token is setup, if using https grab the https clone link from https://github.com/akondur/collect_data_k8s)
- cd collect_data_k8s
- chmod 755 *
- sh collect_data.sh
- Wait till you see the message "All data requried collected"
- Email akondur@splunk.com if you see any issues, good luck!

**Folder breakdown**

**tmp/k8s_data/get** - Contains outputs of kubectl get commands for K8S resources in the cluster

**tmp/k8s_data/describe** - Contains outputs of kubectl describe commands for K8S resources in the cluster

**tmp/diags** - Contains diags from all Splunk Instances running inside of Splunk Enterprise CR pods deployed by the operator. 

**tmp/logs** - Contains logs from all Splunk Enterprise CR pods deployed by the operator and the operator pod itself. 

Note: diags and logs are appropriately named with pod names as prefix

**Performance data**

On a K8S cluster with a **SHC(3 search heads, 1 deployer), IDXC(3 indexers, 1 cluster master), 1 Standalone, 1 License master** as such:

$ kubectl get pods
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

The script has the following performance:

Time taken - **6 mins 40 seconds**
Memory - **774.4 MB**