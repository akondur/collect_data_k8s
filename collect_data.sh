#Collect arguments
helpFunction()
{
   echo ""
   echo "Usage: $0 -d <is_diag_required> -f <destination_folder>"
   echo "\t-d Set to true if you require diag. Field is mandatory"
   echo "\t-f Provide destination folder to store data. Field is not mandatory"
   echo "\t-h Displays usage of script"
   exit 1 # Exit script after printing help
}

while getopts "d:f:h:" opt
do
   case "$opt" in
      d ) diag="$OPTARG" ;;
      f ) folder="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case diag bool is not provided
if [ -z "$diag" ] || [ $diag != "true" ] || [ $diag != "false" ]
then
   echo "Please enter valid value for diag i.e either true or false";
   helpFunction
fi

echo "Starting to collect data with diag $diag in folder $collect_folder \n"

#Setup directory structure
echo "Setting up directories \n"
chmod 755 collect_logs_and_diags.py
mkdir $collect_folder
mkdir $collect_folder/k8s_data
mkdir $collect_folder/k8s_data/get
mkdir $collect_folder/k8s_data/describe
mkdir $collect_folder/logs
mkdir $collect_folder/diags
echo "Done setting up directories \n"

#Get all logs and diags
echo "Started collecting logs and diags \n"
python collect_logs_and_diags.py -d $diag -f $collect_folder
echo "Done collecting logs and diags \n"

#Get cluster dump
echo "Started collecting cluster info \n"
cd $collect_folder/k8s_data/
kubectl cluster-info dump --all-namespaces > clusterinfodump.txt
echo "Done collecting cluster info \n"

#Capture kubectl get command outputs
echo "Started collecting kubectl get command outputs \n"
cd get;
kubectl get all >> all.txt; kubectl get all -o yaml >> all.txt; 
kubectl get nodes >> nodes.txt; kubectl get nodes -o yaml >> nodes.txt;
kubectl get pods >> pods.txt; kubectl get pods -o yaml >> pods.txt;
#kubectl get secrets >> secrets.txt; kubectl get secrets -o yaml >> secrets.txt ---> Collect sensitive data, ignore for now.
kubectl get cm >> configmap.txt; kubectl get cm -o yaml >> configmap.txt;
kubectl get sts >> statefulset.txt; kubectl get sts -o yaml >> statefulset.txt;
kubectl get deployments >> deployment.txt; kubectl get deployments -o yaml >> deployment.txt;
kubectl get services >> services.txt; kubectl get services -o yaml >> services.txt;
kubectl get pvc  >> pvc.txt; kubectl get pvc -o yaml >> pvc.txt;
kubectl get pv >> pv.txt; kubectl get pv -o yaml >> pv.txt;
kubectl get sc  >> storageClass.txt; kubectl get sc -o yaml >> storageClass.txt;
kubectl get serviceaccount >> serviceaccount.txt; kubectl get serviceaccount -o yaml >> serviceaccount.txt;
kubectl get crds >> crds.txt; kubectl get crds -o yaml >> crds.txt;
kubectl api-resources | grep splunk >> api-resources.txt;
kubectl get stdaln  >> standalone.txt; kubectl get stdaln -o yaml >> standalone.txt;
kubectl get idxc >> indexerclusters.txt; kubectl get idxc -o yaml >> indexerclusters.txt;
kubectl get cm-idxc >> clustermasters.txt; kubectl get cm-idxc -o yaml >> clustermasters.txt;
kubectl get shc >> searchheadclusters.txt; kubectl get shc -o yaml >> searchheadclusters.txt;
kubectl get lm >> licensemaster.txt; kubectl get lm -o yaml >> licensemaster.txt;
echo "Done collecting kubectl get command outputs \n"

#Capture kubectl describe command outputs
echo "Started collecting kubectl describe command outputs \n"
cd ../describe
kubectl describe all > all.txt
kubectl describe nodes > nodes.txt
kubectl describe pods  > pods.txt
#kubectl describe secrets  > secrets.txt ---> Collect sensitive data, ignore for now.
kubectl describe cm  > configmap.txt
kubectl describe sts  > statefulset.txt
kubectl describe deployments  > deployment.txt
kubectl describe services  > services.txt
kubectl describe pvc  > pvc.txt
kubectl describe pv  > pv.txt
kubectl describe sc > storageClass.txt
kubectl describe serviceaccount  > serviceaccount.txt
kubectl describe crds  > crds.txt
kubectl describe stdaln  > standalone.txt
kubectl describe idxc  > indexerclusters.txt
kubectl describe cm-idxc  > clustermasters.txt
kubectl describe shc  > searchheadclusters.txt
kubectl describe lm  > licensemaster.txt
echo "Done collecting kubectl describe command outputs \n"

#All done
echo "All data requried collected under folder $collect_folder\n"