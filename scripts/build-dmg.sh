#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="$PROJECT_ROOT/DemoBrowser"
BUILD_DIR="$PROJECT_ROOT/build"
DIST_DIR="$PROJECT_ROOT/dist"
APP_NAME="DemoBrowser"
DMG_NAME="DemoGod.dmg"

echo "==> Cleaning previous builds..."
rm -rf "$BUILD_DIR" "$DIST_DIR"
mkdir -p "$DIST_DIR"

echo "==> Building $APP_NAME (Release)..."
xcodebuild \
  -project "$PROJECT_DIR/$APP_NAME.xcodeproj" \
  -scheme "$APP_NAME" \
  -configuration Release \
  -derivedDataPath "$BUILD_DIR" \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  ONLY_ACTIVE_ARCH=NO \
  -quiet

APP_PATH=$(find "$BUILD_DIR" -name "$APP_NAME.app" -type d | head -1)
if [ -z "$APP_PATH" ]; then
  echo "ERROR: $APP_NAME.app not found in build output"
  exit 1
fi

echo "==> Found app at: $APP_PATH"

echo "==> Creating DMG..."
DMG_TEMP="$DIST_DIR/temp.dmg"
DMG_FINAL="$DIST_DIR/$DMG_NAME"
STAGING="$DIST_DIR/staging"

mkdir -p "$STAGING"
cp -R "$APP_PATH" "$STAGING/"
ln -s /Applications "$STAGING/Applications"

hdiutil create -volname "DemoGod" -srcfolder "$STAGING" -ov -format UDRW "$DMG_TEMP"
hdiutil convert "$DMG_TEMP" -format UDZO -o "$DMG_FINAL"

rm -rf "$STAGING" "$DMG_TEMP"

echo "==> Done! DMG created at: $DMG_FINAL"
echo "    Size: $(du -h "$DMG_FINAL" | cut -f1)"
