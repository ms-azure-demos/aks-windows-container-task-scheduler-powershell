FROM mcr.microsoft.com/windows/servercore:ltsc2019 as runtime
COPY task.xml c:\\
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]
RUN schtasks.exe /Create /XML c:\\task.xml /tn test-task
#RUN ["schtasks","/create", "/sc","minute","/mo","1", "/tn", "'tt-1-min'", "/tr", "powershell.exe -command 'Get-Date | out-file c:\tmp\stask.log -append'","/ST","17:30","/ru","SYSTEM"]
# this container will be running for total 90 secs.30 secs with file and 60 secs without file. If K8s liveness probe is setup on file, it will terminate in 30secs.
#ENTRYPOINT ["powershell.exe", "-command","sc -value 'healthy' c:\\health.txt; echo 'Created file & wait 30 secs'; Sleep -s 30; del c:\\health.txt; echo 'Deleted file & wait for 60 secs'; Sleep -s 60"]
