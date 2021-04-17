from __future__ import print_function
import os
import sys, getopt

def main(argv):
   diag = ''
   collect_folder = ''
   print("Arjun %s \n\n" % str(argv))
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
         diag = arg
      elif opt in ("-f", "--folder"):
         collect_folder = arg
   print ("Is diag enabled %s" % diag)
   print ("Collect folder is %s" % collect_folder)

if __name__ == "__main__":
    main(sys.argv[1:])





