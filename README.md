# QuickShell
QuickShell is a solution for those who often find themselves in situations where they need to work on machines that are not their own. Imagine being able to access your personalized environment settings and tools from anywhere, without having to spend time setting up the environment from scratch. That's exactly what QuickShell offers.

How does it work? You host a Docker container running a Python server on your machine, and when you need your personalized environment settings on another machine, you simply run a command and it will boot up a Tmux environment with the settings you've set up. The best part is that when you're done with the Tmux session, you just exit the script and the files you downloaded to boot up the personalized environment will be cleaned up for you, just like you never changed any settings.

## Installation
### Requirements:
- Docker
- Tmux
- wget
- a machine that has a static ip (you need a static ip so that you can curl the package from other machines)

> ![NOTE]
> some big companies like Amazon, Oracle offer free tier plans to host vm instances that has static ips. So if you don't have a machine that has a static ip and don't plan on paying, feel free to check those out

### Installing from source
```
git clone https://github.com/chenkuanliao/QuickShell.git
cd QuickShell
```

## Usage
### Setting up the server
The first thing is to update the ip for your machine in `quickshell.sh`.

Update `your_static_ip` in the code
```
... code above ...

# Download necessary files
your_static_ip=127.0.0.1 # TODO: update this ip to your static ip that is hosting QuickShell
wget $your_static_ip:8000/runTmux -O QuickShellRun
wget $your_static_ip:8000/my_files/.vimrc -O QuickShellMyFiles/.vimrc
wget $your_static_ip:8000/my_files/.bashrc -O QuickShellMyFiles/.bashrc
wget $your_static_ip:8000/my_files/.tmux.conf -O QuickShellMyFiles/.tmux.conf
wget $your_static_ip:8000/my_files/.zshrc -O QuickShellMyFiles/.zshrc
wget $your_static_ip:8000/my_files/helperTmux.txt -O QuickShellMyFiles/helperTmux.txt

... code below ...
```

Once you have `your_static_ip` updated, run
```
docker-compose up -d
```

To check if the container is running, run
```
docker ps
```

To shut down the container, run
```
docker-compose down
```

### Using your QuickShell server
#### Running your QuickShell
Once you have your server running, now you can try using QuickShell on other machines!

Run
```
wget -O- http://{your_host_ip_or_domain}:8000/quickshell.sh | sh
```

> make sure to replace `your_host_ip_or_domain` with your host's ip or domain

#### Two modes when running QuickShell
Due to how QuickShell is set up, the clean up script is ran when the `quickshell.sh` script is being exited.

Having the `wget -O- http://{your_host_ip_or_domain}:8000/quickshell.sh | sh` command being ran in a tmux session is safer as you won't accidentally exit the script and clean up the files needed for QuickShell.


##### Running it in a tmux session (recommanded)
This means that you will be running the `wget -O- http://{your_host_ip_or_domain}:8000/quickshell.sh | sh` command in a tmux session you created

After running the script, you will be switched to the new Tmux session that runs the QuickShell environment, and you can enjoy your presonalized shell from there!

When you are done and exited from the QuickShell session, you will need to go back to the tmux session you used to run the `wget -O- http://{your_host_ip_or_domain}:8000/quickshell.sh | sh` command. 

> You can run `tmux ls` to check the sessions you are running and run `tmux attach-session -t {session_name}` to attach to that session

To exit the script, do `Ctrl+c` and that will clean up the files.

##### Running it directly in the shell
This means that you will be running the `wget -O- http://{your_host_ip_or_domain}:8000/quickshell.sh | sh` command in the shell 

After running the script, you will be prompted something like
```
Setup complete.
To attach to the tmux session, open a new terminal and run:

  tmux attach-session -t MyZsh

After attaching, you can detach from the session using Ctrl-B followed by D
To end the session completely, type 'exit' when attached to the session


To clean up for this session (remove all the files downloaded for QuickSHell), do

  Ctrl+c



**** Important ****
Please note that you should only exit this script, by doing Ctrl+c, when you are done with the tmux session you created.
Otherwise, the format could be corrupted.
```

You should then launch a new shell and run `tmux attach-session -t MyZsh` (the session name could change depending on the shell you are using), and you can enjoy your presonalized shell from there!

When you are done and exited from the QuickShell session, you will need to go back to the shell you used to run the `wget -O- http://{your_host_ip_or_domain}:8000/quickshell.sh | sh` command. 

To exit the script, do `Ctrl+c` and that will clean up the files.

## DEMO
for DEMO purposes, I am hosting the conatiner on my localhost
### Running it in a tmux session (recommanded)
![DEMO in shell](/others/QuickShell%20Demo%20with%20Tmux.gif)
### Running it directly in the shell
![DEMO in shell](/others/QuickShell%20Demo%20without%20Tmux.gif)