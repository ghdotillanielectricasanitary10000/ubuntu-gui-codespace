# In Order To The Run the Gui Make sure 4 core codespace Run This Command
# 1. Install the core Ubuntu desktop and performance tools
sudo apt update && sudo apt install -y \
    ubuntu-desktop-minimal \
    tigervnc-standalone-server \
    dbus-x11 novnc python3-websockify

# 2. Configure for speed (Disables 3D effects/Animations)
mkdir -p ~/.vnc
cat <<EOF > ~/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
# Crucial for speed: Force CPU rendering
export LIBGL_ALWAYS_SOFTWARE=1
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=Ubuntu:GNOME

# Disable animations before starting
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.wm.preferences visual-bell false

# Launch session with DBus
dbus-launch --exit-with-session gnome-session --session=ubuntu &
EOF
chmod +x ~/.vnc/xstartup

# 3. Start the server (Set your password when prompted)
vncserver -kill :1 > /dev/null 2>&1
vncserver -localhost no :1 -geometry 1280x720 -depth 16 # -depth 16 makes it much faster
/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080 &
