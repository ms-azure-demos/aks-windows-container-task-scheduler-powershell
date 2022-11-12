########## Creating task via command   ##########
# schtasks /create /sc minute /mo 1 /tn "tt-1-min" /tr "powershell.exe /c 'Get-Date | out-file c:\tmp\stask.log -append'" /ST 17:30 /ru SYSTEM
#schtasks.exe /Create /XML task.xml /tn test-task

# Query tasks
#schtasks /S localhost /query /FO table
#schtasks /S localhost /query /XML /TN test-task

########## Building & running locally ##########
docker build -t tmps:latest .
docker run -it tmps:latest cmd
##############################################################################

### Once the container is running give commands inside container cmd shell ###

hostname # to ensure we are inside the container. It will be showing a 12 alpha-numeric name
schtasks /S localhost /query /XML /TN test-task # to check the task created
dir # to see the stask.log file is present in the c:\
type stask.log # to view the contents of file. The task is appending date into the file from PowerShell. 
#docker run mcr.microsoft.com/windows/servercore:ltsc2019 cmd /s /c mkdir c:\tmp

########################### Run inside AKS ####################################

docker tag tmps:latest joymon/task-scheduler-powershell:latest # replace the registry to your choice
docker push joymon/task-scheduler-powershell:latest # replace the registry to your choice

kubectl apply -f .\pod.yaml # replace the registry to your choice inside pod.yaml
#Note that the above command will hold the container running only for **10 mins**.

kubectl get pods # to make sure the pod started
kubectl exec -it pod/taskschedulertest -- cmd

### Inside the container shell ###
hostname # to ensure we are inside the container. It will be showing a 12 alpha-numeric name
schtasks /S localhost /query /XML /TN test-task # to check the task created
dir # to see the stask.log file is present in the c:\
type stask.log # to view the contents of file. The task is appending date into the file from PowerShell. 
