#!/bin/bash

APP_NAME="Celebrate Shortcut"
APP_PATH="$HOME/Applications/$APP_NAME.app"
BUNDLE_ID="com.hugo.celebrate-shortcut"

echo "🗑️  Uninstalling Celebrate Shortcut..."
echo ""

# Stop if running
pkill -f "CelebrateShortcut" 2>/dev/null && echo "⏹  Stopped running app"

# Remove app
if [ -d "$APP_PATH" ]; then
    rm -rf "$APP_PATH"
    echo "🗑️  Removed $APP_PATH"
else
    echo "ℹ️  App not found at $APP_PATH"
fi

# Remove preferences
defaults delete "$BUNDLE_ID" 2>/dev/null
defaults delete "CelebrateShortcut" 2>/dev/null
echo "🗑️  Removed preferences"

# Remove from login items (if added)
osascript -e "tell application \"System Events\" to delete login item \"$APP_NAME\"" 2>/dev/null

echo ""
echo "✅ Celebrate Shortcut has been uninstalled."
