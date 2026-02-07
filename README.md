# QuickShell
QuickShell is a solution for those who often find themselves in situations where they need to work on machines that are not their own. Imagine being able to access your personalized environment settings and tools from anywhere, without having to spend time setting up the environment from scratch. That's exactly what QuickShell offers.

How does it work? You host a Docker container running a Python server on your machine, and when you need your personalized environment settings on another machine, you simply run a command. QuickShell offers two modes:

1. **Tmux mode** — Boots up a Tmux environment with your settings. When you're done, exit the script and all downloaded files are cleaned up automatically, just like you never changed any settings.
2. **Install mode** — Directly installs your configs to the standard locations (`~/.bashrc`, `~/.vimrc`, etc.) for long-term use. Your original configs are backed up, and a restore script is provided to undo everything when you're done.

## Installation
### Requirements:
- Docker
- Tmux
- wget
- a machine that has a static ip (you need a static ip so that you can curl the package from other machines)

> some big companies like Amazon, Oracle offer free tier plans to host vm instances that has static ips. So if you don't have a machine that has a static ip and don't plan on paying, feel free to check those out

### Installing from source
```
git clone https://github.com/chenkuanliao/QuickShell.git
cd QuickShell
```

## Usage
### Setting up the server
The first thing is to update the ip for your machine in `quickshell.sh` and `quickshell_install.sh`.

Update `your_static_ip` in both files
```
your_static_ip=127.0.0.1 # TODO: update this ip to your static ip that is hosting QuickShell
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
Once you have your server running, now you can try using QuickShell on other machines!

> make sure to replace `your_host_ip_or_domain` with your host's ip or domain in the commands below

#### Mode 1: Tmux mode (temporary session)
Best for quick access when you don't need a permanent setup. Requires tmux.

Run
```
wget -O- http://{your_host_ip_or_domain}:8000/quickshell.sh | sh
```

#### Two ways to run Tmux mode
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

#### Mode 2: Install mode (persistent setup)
Best for machines you'll be working on for a long time. Does not require tmux.

Run
```
wget -O- http://{your_host_ip_or_domain}:8000/quickshell_install.sh | sh
```

This will:
- Back up your existing config files (`.bashrc`, `.zshrc`, `.cshrc`, `.vimrc`, `.tmux.conf`) to `~/.quickshell_backup/`
- Replace them with your QuickShell configs
- Open a new shell to start using your personalized environment

When you're done (e.g., handing the machine to someone else), restore the original configs by running:
```
~/.quickshell_backup/quickshell_restore.sh
```

This will restore all original config files and remove everything QuickShell added. If a config file didn't exist before QuickShell was installed, it will be removed.

> Note: You cannot run install mode twice. If you want to reinstall, run the restore script first.

### Setting up your own environment
All the personalized config files are in the `my_files` directory.

Currently, QuickShell supports `zsh`, `csh`, and `bash`. The `my_files` directory consists of the following files
- `.bashrc`
- `.zshrc`
- `.tmux.conf`
- `.vimrc`
- `.cshrc`
- `helperTmux.txt`

The first five files are just config files, and you can always replace them with your own personalized files

The `helperTmux.txt` file is a file I use to get informations about commands for Tmux. There is a function/alias called `htmux` in `.bashrc`, `.cshrc`, and `.zshrc` that uses this file to return the information.


## DEMO
for DEMO purposes, I am hosting the conatiner on my localhost
### Running it in a tmux session (recommanded)
![DEMO in shell](/others/QuickShell%20Demo%20with%20Tmux.gif)
### Running it directly in the shell
![DEMO in shell](/others/QuickShell%20Demo%20without%20Tmux.gif)