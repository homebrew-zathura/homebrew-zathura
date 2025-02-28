#!/usr/bin/env bash

echo "This script will convert the zathura binary into a macOS App"



[ -f /opt/homebrew/bin/zathura ] || { echo "zathura not found at /opt/homebrew/bin/zathura"; exit 1; }


echo "Creating /Applications/Zathura.app"
mkdir -p /Applications/Zathura.app/Contents/MacOS
mkdir -p /Applications/Zathura.app/Contents/Resources

cp /opt/homebrew/bin/zathura /Applications/Zathura.app/Contents/MacOS/zathura

touch /Applications/Zathura.app/Contents/Info.plist

echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>Zathura</string>
    <key>CFBundleDisplayName</key>
    <string>Zathura</string>
    <key>CFBundleIdentifier</key>
    <string>com.pwmt.zathura</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleExecutable</key>
    <string>zathura</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
</dict>
</plist>" > /Applications/Zathura.app/Contents/Info.plist

echo "Making it executable"
chmod +x /Applications/Zathura.app/Contents/MacOS/zathura

cat << EOF
Now you can run the app by double clicking on it.

Next steps:
To change the icon, follow the README.md in the repo.

You will notice that when Zathura opens, no file is showing. To open a file, type \`:open <path to file>\`. Pressing <Tab> will show some recent files that the viewerhas opened
EOF
