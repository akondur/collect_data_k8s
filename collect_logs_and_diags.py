from __future__ import print_function
import os
import sys, getopt

def executeShellCommand(command):
   stream = os.popen(command)
   output = stream.read()
   return output


def runAndCollectDiag(collectDir, podDiagsDir, pod):
    output = executeShellCommand("kubectl exec --stdin %s -- /opt/splunk/bin/splunk diag;" % pod)
    for line in output.splitlines():
        words = line.split()
        if len(words) > 4 and "Splunk diagnosis file created:" in line:
            #Extract diag file name and full path
            diagFileFullPath = words[4]
            diagFile = ""
            dirs = diagFileFullPath.split('/')
            if len(dirs) >= 2 and len(dirs[3]) > 0:
                diagFile = dirs[3]

            #Copy the diag over            
            executeShellCommand("kubectl cp %s:%s $PWD/%s/%s/%s" % (pod, diagFileFullPath, collectDir, podDiagsDir, diagFile))

            #Delete the diag
            executeShellCommand("kubectl exec --stdin %s -- rm -rf %s" % (pod, diagFileFullPath))
            executeShellCommand("kubectl exec --stdin %s -- rm -rf /opt/splunk/diag*" % (pod))


def main(argv):
    #Define required variables
    collectDiag = ''
    collectDir = ''
    podLogsDir = "logs"
    podDiagsDir = "diags"

    try:
        opts, args = getopt.getopt(argv,"d:f:",["diag=","folder="])
    except getopt.GetoptError:
        print ("Use the format collect_logs_and_diags.py -d <diag> -f <collectFolder>")
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print ("Use the format collect_logs_and_diags.py -d <diag> -f <collectFolder>")
            sys.exit()
        elif opt in ("-d", "--diag"):
            collectDiag = arg
        elif opt in ("-f", "--folder"):
            collectDir = arg

    # Collect logs from the operator
    output = executeShellCommand("kubectl logs deployment/splunk-operator > %s/%s/operator.log" % (collectDir, podLogsDir))
    output = executeShellCommand("kubectl logs -l app.kubernetes.io/managed-by=splunk-operator --tail -1 > %s/%s/splunkEnterprisePods.log" % (collectDir, podLogsDir))

    output = executeShellCommand("kubectl get pods")
    for line in output.splitlines():
        words = line.split()
        if "splunk" in words[0]:
            pod = words[0]

            # Collect logs from pod
            executeShellCommand("kubectl logs %s > %s/%s/%s.log" % (pod, collectDir, podLogsDir, pod))

            # Skip operator pod for diag purposes
            if "operator" in pod:
                continue

            # Collect diag and save diag from all Splunk Instances
            if collectDiag == "true":
                runAndCollectDiag(collectDir, podDiagsDir, pod)

if __name__ == "__main__":
    main(sys.argv[1:])





