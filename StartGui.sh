# In Order To The Run the Gui Make sure 4 core codespace Run This Command
# 1. Install the core Ubuntu desktop and performance tools
sudo apt update && sudo apt install -y \
    ubuntu-desktop-minimal \
    tigervnc-standalone-server \
    dbus-x11 novnc python3-websockify xterm

# 2. Configure for a stable container-friendly VNC session
mkdir -p ~/.vnc
cat <<'EOF' > ~/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export LIBGL_ALWAYS_SOFTWARE=1
export XDG_SESSION_TYPE=x11

# This minimal X session stays alive in a headless Codespace/container
exec /usr/bin/xterm
EOF
chmod +x ~/.vnc/xstartup

# 3. Start the server (set your VNC password when prompted)
# Stop any old sessions before starting a clean one.
vncserver -kill :1 > /dev/null 2>&1 || true
pkill -f 'websockify.*6080' > /dev/null 2>&1 || true

vncserver -localhost no :1 -geometry 1280x720 -depth 16 # -depth 16 makes it much faster
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 --web /usr/share/novnc >/tmp/novnc.log 2>&1 &

echo "GUI is starting on http://localhost:6080"
echo "If you're in Codespaces, open the forwarded port for 6080 in the browser."
