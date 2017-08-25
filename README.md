# desktop-agent-core-internal

Ex. docker build command where Dockerfile is stored at c:\build\Dockerfile

`docker build -t desktop-agent c:\build --build-arg CLASSIC_AGENT_HOST=<IP or hostname of Desktop 8.0 server> --build-arg CLASSIC_AGENT_PORT=443 --build-arg CLASSIC_AGENT_KEY=<actual unencrypted key> --build-arg CLASSIC_AGENT_KEY_ENCRYPTED=False --build-arg DOWNLOAD_ZIP_URL="<https://path/to/windows.zip/containing/msi/packages>"`

After a successful build:

## View images 
`docker images`

## Run the new image in a container
`docker run -dit desktop-agent`
 
The container is launched in the background with interactive mode enabled, which means we can "attach" to the container's console.

## Lookup the name of the container (its dynamic)
`docker ps -a`
 
## Then attach to the console using
`docker attach <dynamic name>`
 
After running docker attach you'll have a cmd console. You can call powershell to get a PS console.
You can detach and leave the container running using Ctrl+P , Ctrl+Q.
