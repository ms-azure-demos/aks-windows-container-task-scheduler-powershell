# Running PowerShell based scheduled task in windows container on AKS

# Aim

To schedule a task inside Windows container and ensure its triggering

# How to run - Docker

- Open the commands.ps1 and execute
- It builds the image and run interactively.
- It already has commands to run once the container starts
- If all working good the c:\stask.log file in container will be appended with date time every minute

# How to run - Kubernetes

- Follow the instructions in the "Run inside AKS" of commands.ps1
  - Mainly tag and push the image to your registry 
  - After replacing your registry execute `kubectl apply -f pod.yaml`
    - Note that this will hold the container running only for **10 mins**.
  - If the image registry is not replaced it will be taking image from my dockerhub registry
  - exec into the container and ensure the c:\stask.log file is getting updated

# Environment

- Base image - mcr.microsoft.com/windows/servercore:ltsc2019
- Scheduled task technology - PowerShell

# Design

Below are some points about how it is structured

- The tasks.xml file has the task definition
- Task logic
  - The powershell command appends the Get-Date to c:\stask.log file
- Dockerfile gets the task.xml file and create task using `schtasks.exe`
- For testing container can be started in interactive mode (with -it switch)
- Dockerfile can have entrypoint when using this for production.

# Interesting

  - The Dockerfile don't have any EntryPoint to hold the container when running inside AKS. So pod.yaml needs to hold it for sometime with the help of args. Ideally `timeout 600` is enough but it will throw **"ERROR: Input redirection is not supported, exiting the process immediately"**. To workaround that the pod.yaml file uses `start /wait` [with timeout](https://stackoverflow.com/questions/32307870/add-a-timeout-between-two-batch-command-lines-in-jenkins)