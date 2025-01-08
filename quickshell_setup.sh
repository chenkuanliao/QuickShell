#!/bin/sh

# Create my_files directory if it doesn't exist
mkdir -p my_files

case "$SHELL" in
    *zsh*)
        MY_SHELL="zsh"
        ;;
    *bash*)
        MY_SHELL="bash"
        ;;
    *)
        echo "Unsupported shell: $SHELL"
        MY_SHELL="unsupported"
        ;;
esac

# Download necessary files
your_static_ip=127.0.0.1
wget $your_static_ip:8000/runTmux
wget $your_static_ip:8000/my_files/.bashrc -O my_files/.bashrc
wget $your_static_ip:8000/my_files/.tmux.conf -O my_files/.tmux.conf
wget $your_static_ip:8000/my_files/.zshrc -O my_files/.zshrc
wget $your_static_ip:8000/my_files/helperTmux.txt -O my_files/helperTmux.txt

# Make runTmux executable
chmod +x runTmux

# Run the tmux session
./runTmux "My$MY_SHELL" &

# Wait for the tmux session to start
sleep 1

# Cleanup function
cleanup() {
    rm -rf runTmux my_files
    rm -f quickshell_setup.sh
}

# Set trap to run cleanup on exit
# trap cleanup EXIT
trap 'cleanup; exit' EXIT INT TERM


# Attach to the tmux session
if [ -n "$TMUX" ]; then
    # If already in a tmux session, switch to the new one
    echo "switching to your targeted tmux session"
    tmux switch-client -t "My$MY_SHELL"
else
    # If not in a tmux session, provide instructions to the user
    clear  # Clear the screen for cleaner output
    echo "Setup complete. "
    echo "To attach to the tmux session, open a new terminal and run:"
    echo ""
    echo "  tmux attach-session -t My$MY_SHELL"
    echo ""
    echo "After attaching, you can detach from the session using Ctrl-B followed by D"
    echo "To end the session completely, type 'exit' when attached to the session"
    echo ""
    echo "To clean up for this session (remove all the files downloaded for QuickSHell), do"
    echo ""
    echo "  Ctrl+c"
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
