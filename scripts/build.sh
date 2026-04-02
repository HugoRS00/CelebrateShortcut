#!/bin/bash
set -e

APP_NAME="Celebrate Shortcut"
BUNDLE_ID="com.hugo.celebrate-shortcut"
BUILD_DIR="/tmp/celebrate-shortcut-build"
APP_DIR="$HOME/Applications"
APP_PATH="$APP_DIR/$APP_NAME.app"

echo "🎉 Building Celebrate Shortcut..."
echo ""

# Build
cd "$(dirname "$0")/.."
PROJECT_DIR="$(pwd)"

# Copy to temp for building (avoids sandbox issues)
rm -rf "$BUILD_DIR"
cp -r "$PROJECT_DIR" "$BUILD_DIR"
cd "$BUILD_DIR"

swift build -c release --build-path "$BUILD_DIR/.build" 2>&1 | tail -1

BINARY="$BUILD_DIR/.build/release/CelebrateShortcut"

if [ ! -f "$BINARY" ]; then
    echo "❌ Build failed"
    exit 1
fi

# Create .app bundle
echo "📦 Creating app bundle..."
mkdir -p "$APP_DIR"
rm -rf "$APP_PATH"
mkdir -p "$APP_PATH/Contents/MacOS"
mkdir -p "$APP_PATH/Contents/Resources"

cp "$BINARY" "$APP_PATH/Contents/MacOS/CelebrateShortcut"

# Copy resources if they exist
if [ -d "$BUILD_DIR/.build/release/CelebrateShortcut_CelebrateShortcut.bundle" ]; then
    cp -r "$BUILD_DIR/.build/release/CelebrateShortcut_CelebrateShortcut.bundle" "$APP_PATH/Contents/Resources/"
fi

# Create Info.plist
cat > "$APP_PATH/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>Celebrate Shortcut</string>
    <key>CFBundleDisplayName</key>
    <string>Celebrate Shortcut</string>
    <key>CFBundleIdentifier</key>
    <string>com.hugo.celebrate-shortcut</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleExecutable</key>
    <string>CelebrateShortcut</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSUIElement</key>
    <true/>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
</dict>
</plist>
PLIST

# Cleanup
rm -rf "$BUILD_DIR"

echo ""
echo "✅ Installed to: $APP_PATH"
echo ""
echo "🚀 To start: open \"$APP_PATH\""
echo "   Or just run: open -a 'Celebrate Shortcut'"
echo ""
echo "Default shortcut: ⌘⇧C (Cmd+Shift+C)"
echo ""

# Ask to launch
read -p "Launch now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "$APP_PATH"
    echo "🎉 Running! Look for the 🎉 icon in your menu bar."
fi
