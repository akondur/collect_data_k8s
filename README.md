# collect_data_k8s

A repository which defines how we collect data from a K8S cluster which runs the Splunk Operator for K8S. It involves collecting data via kubectl commands, splunk data via diag etc..

Requirements to run the script:

- Root access on the host file system with access to the K8S cluster running the operator
- Access to create/delete directories
- Access to kubectl commands to get data
