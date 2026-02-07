#!/bin/sh

# QuickShell Install Mode
# Installs personalized shell configs to standard locations (~/.bashrc, etc.)
# Backs up existing configs and generates a restore script

BACKUP_DIR="$HOME/.quickshell_backup"
MANIFEST="$BACKUP_DIR/manifest.txt"

# Check if wget is available
if ! hash wget 2>/dev/null; then
    echo "wget is not installed. Please install it first."
    exit 1
fi

# Prevent double install
if [ -d "$BACKUP_DIR" ]; then
    echo "QuickShell is already installed."
    echo "To reinstall, first restore your original configs by running:"
    echo ""
    echo "  qsrestore"
    echo ""
    exit 1
fi

# Server address
your_static_ip=127.0.0.1 # TODO: update this ip to your static ip that is hosting QuickShell
SERVER="$your_static_ip:8000"

# Create backup directory and manifest
mkdir -p "$BACKUP_DIR"
: > "$MANIFEST"

# List of config files to install
CONFIG_FILES=".bashrc .zshrc .cshrc .vimrc .tmux.conf"

# Generate restore script first (so it exists even if install fails partway)
cat > "$BACKUP_DIR/quickshell_restore.sh" << 'RESTORE_EOF'
#!/bin/sh

BACKUP_DIR="$HOME/.quickshell_backup"
MANIFEST="$BACKUP_DIR/manifest.txt"

if [ ! -f "$MANIFEST" ]; then
    echo "No QuickShell installation found."
    exit 1
fi

echo "Restoring original configs..."

while IFS= read -r line; do
    status="${line%%:*}"
    filepath="${line#*:}"
    filename="$(basename "$filepath")"

    case "$status" in
        EXISTED)
            if [ -f "$BACKUP_DIR/${filename}.bak" ]; then
                cp "$BACKUP_DIR/${filename}.bak" "$filepath"
                echo "  Restored $filepath"
            else
                echo "  Warning: backup for $filepath not found, skipping"
            fi
            ;;
        NEW)
            rm -f "$filepath"
            echo "  Removed $filepath (did not exist before)"
            ;;
    esac
done < "$MANIFEST"

# Remove backup directory and everything in it (including this script)
rm -rf "$BACKUP_DIR"
echo ""
echo "QuickShell has been uninstalled and your original configs have been restored."
RESTORE_EOF
chmod +x "$BACKUP_DIR/quickshell_restore.sh"

# Backup existing configs and download QuickShell versions
echo "Installing QuickShell configs..."
echo ""

for file in $CONFIG_FILES; do
    target="$HOME/$file"

    # Backup or record
    if [ -f "$target" ]; then
        cp "$target" "$BACKUP_DIR/${file}.bak"
        echo "EXISTED:$target" >> "$MANIFEST"
        echo "  Backed up $target"
    else
        echo "NEW:$target" >> "$MANIFEST"
    fi

    # Download to temp file first, then move into place
    # (wget -O truncates the target immediately, which would destroy the file on a failed download)
    dltemp=$(mktemp)
    if wget -q "$SERVER/my_files/$file" -O "$dltemp"; then
        mv "$dltemp" "$target"
        echo "  Installed $target"
    else
        rm -f "$dltemp"
        echo "  Failed to download $file. Run the restore script to undo partial install:"
        echo "    $BACKUP_DIR/quickshell_restore.sh"
        echo "  (or type 'qsrestore' after opening a new shell)"
        exit 1
    fi
done

# Download helperTmux.txt for the htmux alias
dltemp=$(mktemp)
if wget -q "$SERVER/my_files/helperTmux.txt" -O "$dltemp"; then
    mv "$dltemp" "$BACKUP_DIR/helperTmux.txt"
else
    rm -f "$dltemp"
    echo "  Warning: failed to download helperTmux.txt, htmux alias will not work"
fi

# Prepend MY_FILES variable to shell configs so htmux alias works
for file in .bashrc .zshrc; do
    target="$HOME/$file"
    tmpfile=$(mktemp)
    echo "MY_FILES=\"$BACKUP_DIR\"" > "$tmpfile"
    cat "$target" >> "$tmpfile"
    mv "$tmpfile" "$target"
done

# csh uses setenv syntax
target="$HOME/.cshrc"
tmpfile=$(mktemp)
echo "setenv MY_FILES $BACKUP_DIR" > "$tmpfile"
cat "$target" >> "$tmpfile"
mv "$tmpfile" "$target"

echo ""
echo "QuickShell installed successfully!"
echo ""
echo "To uninstall and restore your original configs, run:"
echo ""
echo "  qsrestore"
echo ""

# Launch a new interactive shell so configs take effect immediately
echo "Launching a new shell with your configs..."
exec "$SHELL" < /dev/tty
