# escape=`
FROM microsoft/windowsservercore
ARG AGENT_VERSION
ARG CLASSIC_AGENT_KEY
ARG CLASSIC_AGENT_HOST
ARG CLASSIC_AGENT_PORT
ARG CLASSIC_AGENT_KEY_ENCRYPTED
ARG DOWNLOAD_ZIP_URL

SHELL ["powershell", "-Command"]

#download windows.zip containing agent msi's
RUN [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} ; `
(New-Object System.Net.WebClient).DownloadFile($Env:DOWNLOAD_ZIP_URL, 'windows.zip');

#extract msis
RUN $BackUpPath = \"C:\windows.zip\" ; `
$destination = \"C:\desktop-agent\" ; `
Expand-Archive -Path $BackUpPath -DestinationPath $destination -Force;

#run msi installation of agent
RUN $ver = $Env:AGENT_VERSION; `
$args = \"/i C:\desktop-agent\dist\$ver\win\SpiceworksAgentShell_classic-agent_$ver.msi /qn CLASSIC_AGENT_KEY=\" + $Env:CLASSIC_AGENT_KEY + \" CLASSIC_AGENT_KEY_ENCRYPTED=\" + $Env:CLASSIC_AGENT_KEY_ENCRYPTED + \" CLASSIC_AGENT_PORT=\" + $Env:CLASSIC_AGENT_PORT + \" CLASSIC_AGENT_HOST=\" + $Env:CLASSIC_AGENT_HOST + \" /lv install.log\"; `
Start-Process msiexec.exe -Wait -ArgumentList $args;

#clean up, removing all msi installers
RUN Remove-Item C:\desktop-agent -Recurse -Force; `
Remove-Item C:\windows.zip;

#startup and monitor agent service, ref. https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/master/windows-server-container-tools/Wait-Service
ADD https://raw.githubusercontent.com/MicrosoftDocs/Virtualization-Documentation/master/windows-server-container-tools/Wait-Service/Wait-Service.ps1 C:\Wait-Service.ps1
ENTRYPOINT powershell.exe -file c:\Wait-Service.ps1 -ServiceName agentshellservice

#agent shell windows service status = container health
HEALTHCHECK CMD powershell -command `  
    try { `
	$serviceInfo = service -name agentshellservice; `
	$response = $serviceInfo.status -eq "Running"; `
     if ($response) { return 0} `
     else {return 1}; `
    } catch { return 1 }
