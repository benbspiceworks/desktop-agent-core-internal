# desktop-agent-core-internal

Ex. docker build command where Dockerfile is stored at c:\build\Dockerfile

`docker build -t desktop-agent c:\build --build-arg CLASSIC_AGENT_HOST=<IP or hostname of Desktop 8.0 server> --build-arg CLASSIC_AGENT_PORT=443 --build-arg CLASSIC_AGENT_KEY=<actual unencrypted key> --build-arg CLASSIC_AGENT_KEY_ENCRYPTED=False --build-arg DOWNLOAD_ZIP_URL="<https://path/to/windows.zip/containing/msi/packages>"`
