from __future__ import print_function
import os

def executeShellCommand(command):
   stream = os.popen(command)
   output = stream.read()
   return output


def runAndCollectDiag(podDiagsDir, pod):
    output = executeShellCommand("kubectl exec --stdin %s -- /opt/splunk/bin/splunk diag;" % pod)
    for line in output.splitlines():
        words = line.split()
        if len(words) > 4 and "Splunk diagnosis file created:" in line:
            diagFile = words[4]
            executeShellCommand("kubectl cp %s:%s $PWD/tmp/%s/%s-diag.tgz" % (pod, diagFile, podDiagsDir, pod))

def main():
    podLogsDir = "logs"
    podDiagsDir = "diags"

    # Collect logs from the operator
    output = executeShellCommand("kubectl logs deployment/splunk-operator > tmp/%s/operator.log" % podLogsDir)
    output = executeShellCommand("kubectl logs -l app.kubernetes.io/managed-by=splunk-operator --tail -1 > tmp/%s/splunkEnterprisePods.log" % podLogsDir)

    output = executeShellCommand("kubectl get pods")
    for line in output.splitlines():
        words = line.split()
        if "splunk" in words[0]:
            pod = words[0]
            # Collect logs from pod
            executeShellCommand("kubectl logs %s > tmp/%s/%s.log" % (pod, podLogsDir, pod))

            # Skip operator pod for diag purposes
            if "operator" in pod:
                continue

            # Collect diag and save diag from all Splunk Instances
            runAndCollectDiag(podDiagsDir, pod)

if __name__ == "__main__":
    main()





