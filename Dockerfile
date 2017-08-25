# escape=`
FROM microsoft/windowsservercore
ARG AGENT_VERSION
ARG CLASSIC_AGENT_KEY
ARG CLASSIC_AGENT_HOST
ARG CLASSIC_AGENT_PORT
ARG CLASSIC_AGENT_KEY_ENCRYPTED
ARG DOWNLOAD_ZIP_URL

SHELL ["powershell", "-Command"]

RUN [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} ; `
(New-Object System.Net.WebClient).DownloadFile($Env:DOWNLOAD_ZIP_URL, 'windows.zip');

RUN $BackUpPath = \"C:\windows.zip\" ; `
$destination = \"C:\desktop-agent\" ; `
Expand-Archive -Path $BackUpPath -DestinationPath $destination -Force;

RUN $args = \"/i C:\desktop-agent\dist\0.3.17\win\SpiceworksAgentShell_classic-agent_0.3.17.msi /qn CLASSIC_AGENT_KEY=\" + $Env:CLASSIC_AGENT_KEY + \" CLASSIC_AGENT_KEY_ENCRYPTED=\" + $Env:CLASSIC_AGENT_KEY_ENCRYPTED + \" CLASSIC_AGENT_PORT=\" + $Env:CLASSIC_AGENT_PORT + \" CLASSIC_AGENT_HOST=\" + $Env:CLASSIC_AGENT_HOST + \" /lv install.log\"; `
Start-Process msiexec.exe -Wait -ArgumentList $args;

RUN Remove-Item C:\desktop-agent -Recurse -Force; `
Remove-Item C:\windows.zip;
