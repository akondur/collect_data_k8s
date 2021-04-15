mkdir tmp
cd tmp
kubectl cluster-info --all-namespaces > clusterinfodump.txt

mkdir get
cd get
kubectl get all -o yaml > all.txt
kubectl get nodes -o yaml > nodes.txt
kubectl get pods -o yaml > pods.txt
kubectl get secrets -o yaml > secrets.txt
kubectl get cm -o yaml > configmap.txt
kubectl get sts -o yaml > statefulset.txt
kubectl get deployments -o yaml > deployment.txt
kubectl get services -o yaml > services.txt
kubectl get pvc -o yaml > pvc.txt
kubectl get pv -o yaml > pv.txt
kubectl get serviceaccount -o yaml > serviceaccount.txt
kubectl get crds -o yaml > crds.txt
kubectl api-resources | grep splunk > api-resources.txt
kubectl get stdaln -o yaml > standalone.txt
kubectl get idxc -o yaml > indexerclusters.txt
kubectl get cm-idxc -o yaml > clustermasters.txt
kubectl get shc -o yaml > searchheadclusters.txt
kubectl get lm -o yaml > licensemaster.txt

cd ../
mkdir describe
cd describe
kubectl describe all > all.txt
kubectl describe nodes > nodes.txt
kubectl describe pods  > pods.txt
kubectl describe secrets  > secrets.txt
kubectl describe cm  > configmap.txt
kubectl describe sts  > statefulset.txt
kubectl describe deployments  > deployment.txt
kubectl describe services  > services.txt
kubectl describe pvc  > pvc.txt
kubectl describe pv  > pv.txt
kubectl describe serviceaccount  > serviceaccount.txt
kubectl describe crds  > crds.txt
kubectl describe stdaln  > standalone.txt
kubectl describe idxc  > indexerclusters.txt
kubectl describe cm-idxc  > clustermasters.txt
kubectl describe shc  > searchheadclusters.txt
kubectl describe lm  > licensemaster.txt


cd ../
mkdir logs
cd logs
kubectl logs deployment/splunk-operator > operator.log
kubectl logs -l app.kubernetes.io/managed-by=splunk-operator --tail -1 > splunkEnterprisePods.log

