#Collect arguments
helpFunction()
{
   echo ""
   echo "Usage: $0 -d <is_diag_required> -f <destination_folder> -a <avoid_kubectl_describe>"
   echo "\t-d Set to true if you require diag. Field is mandatory"
   echo "\t-f Provide destination folder to store data. Field is not mandatory"
   echo "\t-a Set to true if you want to avoid kubectl describe commands. Use option only if avoiding kubectl describe commands. Field is not mandatory"
   echo "\t-h Displays usage of script"
   exit 1 # Exit script after printing help
}

while getopts "d:f:a:" opt
do
   case "$opt" in
      d ) diag="$OPTARG" ;;
      f ) folder="$OPTARG" ;;
      a ) avoiddescribe="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case diag bool is not provided or has invalid options
if [ -z "$diag" ] || ([ $diag != "true" ] && [ $diag != "false" ])
then
   echo "Please enter valid value for diag i.e either true or false. -d option cannot be avoided or be empty";
   helpFunction
fi

# Print helpFunction in case avoid describe flag is not used properly
if [ ! -z "$avoiddescribe" ] && [ $avoiddescribe != "true" ]
then
   echo "Please enter valid value for -a option i.e set to true or else avoid option. Use option only if avoiding kubectl describe commands";
   helpFunction
fi

# Determine full path of where the data needs to be collected
if [ -z "$folder" ]
then
   collect_folder=$PWD/tmp-$(date "+%F-%H-%M")
else 
   collect_folder=$folder/tmp-$(date "+%F-%H-%M")
fi

echo "Starting to collect data with diag $diag in folder $collect_folder \n"

#Setup directory structure
echo "Setting up directories \n"
chmod 755 collect_logs_and_diags.py
mkdir -p $collect_folder/
mkdir -p $collect_folder/pod_data
mkdir -p $collect_folder/k8s_data
mkdir -p $collect_folder/k8s_data/get
if [ -z "$avoiddescribe" ]
then
   mkdir -p $collect_folder/k8s_data/describe
fi
mkdir -p $collect_folder/pod_data/logs
if [ $diag == "true" ]
then
   mkdir -p $collect_folder/pod_data/diags
fi
echo "Done setting up directories \n"

## Loop through pods and get logs/diags via python script

#Get all pod related logs and diags
echo "Started collecting logs and diags \n"
python collect_logs_and_diags.py -d $diag -f $collect_folder
echo "Done collecting logs and diags \n"

## Get K8S resources related data via kubectl get and describe commands

#Get cluster dump
echo "Started collecting cluster info \n"
cd $collect_folder/k8s_data/
kubectl cluster-info dump --all-namespaces > clusterinfodump.txt
echo "Done collecting cluster info \n"

#Capture kubectl get command outputs
echo "Started collecting kubectl get command outputs \n"
cd $collect_folder/k8s_data/get;
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

# Implement kubectl describe only if -a option is not used. Avoid describe if -a option is set to true
if [ -z "$avoiddescribe" ]
then
   #Capture kubectl describe command outputs
   echo "Started collecting kubectl describe command outputs \n"
   cd $collect_folder/k8s_data/describe;
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
fi

#All done
echo "All data requried collected under folder $collect_folder\n"