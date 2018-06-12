# docker_php7_start_script

## Requirements

*  Install Docker [mac os](https://docs.docker.com/docker-for-mac/)
*  Might need to install virtual machine, depending on the Docker version you choose. 

Please Note: Docker terminal comes with Docker, but one can also use any shell to access docker by first initializing the shell with the docker host. 

i.e. command below will init the terminal so that you don't have to use Docker terminal.
```
eval "$(docker-machine env phpdocker)"
```


## To run the start script 

```
sh scripts/create-starter-environment.sh
```

You will be prompted to confirm whether you want to create a new host `phpdocker`.

FYI: The script runs some commands that builds the default environment set in /Dockerfile, if you wanted to make any adjustments to your server, you can just edit your Dockerfile.
