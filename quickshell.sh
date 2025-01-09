#!/bin/sh

# Check if tmux is installed
if hash tmux 2>/dev/null; then
    # If tmux is installed, proceed with the setup
    # Create QuickShellMyFiles directory if it doesn't exist
    mkdir -p QuickShellMyFiles

    # detect the current shell
    case "$SHELL" in
        *zsh*)
            MY_SHELL="Zsh"
            ;;
        *bash*)
            MY_SHELL="Bash"
            ;;
        *csh*)
            MY_SHELL="Csh"
            ;;
        *)
            echo "Unsupported shell: $SHELL"
            MY_SHELL="unsupported"
            ;;
    esac

    # Download necessary files
    your_static_ip=127.0.0.1 # TODO: update this ip to your static ip that is hosting QuickShell
    wget $your_static_ip:8000/runTmux -O QuickShellRun
    wget $your_static_ip:8000/my_files/.vimrc -O QuickShellMyFiles/.vimrc
    wget $your_static_ip:8000/my_files/.bashrc -O QuickShellMyFiles/.bashrc
    wget $your_static_ip:8000/my_files/.tmux.conf -O QuickShellMyFiles/.tmux.conf
    wget $your_static_ip:8000/my_files/.zshrc -O QuickShellMyFiles/.zshrc
    wget $your_static_ip:8000/my_files/helperTmux.txt -O QuickShellMyFiles/helperTmux.txt

    # Make QuickShellRun executable
    chmod +x QuickShellRun

    # Run the tmux session
    ./QuickShellRun "My$MY_SHELL" &

    # Wait for the tmux session to start
    sleep 1

    # Cleanup function
    cleanup() {
        rm -rf QuickShellRun QuickShellMyFiles
        rm -f quickshell.sh
    }

    # Set trap to run cleanup on exit
    trap 'cleanup; exit' EXIT INT TERM

    # Attach to the tmux session
    if [ -n "$TMUX" ]; then
        # If already in a tmux session, switch to the new one
        echo "switching to your targeted tmux session"
        tmux switch-client -t "My$MY_SHELL"
    else
        # If not in a tmux session, provide instructions to the user
        clear
        echo "Setup complete. "
        echo "To attach to the tmux session, open a new terminal and run:"
        echo ""
        echo "  tmux attach-session -t My$MY_SHELL"
        echo ""
        echo "After attaching, you can detach from the session using Ctrl-B followed by D"
        echo "To end the session completely, type 'exit' when attached to the session"
        echo ""
        echo ""
        echo "To clean up for this session (remove all the files downloaded for QuickShell), do"
        echo ""
        echo "  Ctrl+c"
        echo ""
        echo ""
        echo ""
        echo "**** Important ****"
        echo "Please note that you should only exit this script, by doing Ctrl+c, when you are done with the tmux session you created."
        echo "Otherwise, the format could be corrupted."
    fi

    # Keep the script running until the user exits
    while true; do
        sleep 1
    done

    # The script will end here when the user detaches or exits the tmux session

else
    # If tmux is not installed, inform the user and exit
    echo "tmux is not installed. Please install it first."
fi
