# collect_data_k8s

A repository which helps provide a script to collect data from a K8S cluster which runs the Splunk Operator for K8S. It involves collecting data via kubectl commands, splunk data via diag etc..

NOTE of caution, the script:  
- Collects extensive data on your K8S cluster. If there is any data you'd like to keep private please avoid using the script(modify it as per your needs)
- Generates splunk diag on all of your Splunk Instances running inside of Splunk Enterprise CR pods deployed by the operator. 

If any of the above is not desired, please resort to collecting data manually.

Requirements to run the script:

- Kubeconfig context set to the cluster running the Splunk Operator for Kubernetes
- Access to kubectl commands to get data
- Root access on the host file system to create/delete directories(atleast within the directory where you want to run this script and store logs)
- Enough space to collect data in the folder

Script run instructions:

- Make sure you meet requirements above.
- Get access to a terminal and find a folder on your machine where there is enough space to collect data. Move the cursor context to that folder(In linux, macos "cd" to that folder)
- "git clone git@github.com:akondur/collect_data_k8s.git" (make sure ssh token is setup, if using https grab the https clone link from https://github.com/akondur/collect_data_k8s)
- cd collect_data_k8s
- chmod 755 *
- sh collect_data.sh
- Wait till you see the message "All data requried collected"
- Email akondur@splunk.com if you see any issues, good luck!
