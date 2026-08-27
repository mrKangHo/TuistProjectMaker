#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

swift build -c debug

APP_NAME="TuistProjectMaker"
BIN_NAME="TuistProjectMaker"
BUILD_BIN=".build/debug/${BIN_NAME}"
APP_BUNDLE=".build/${APP_NAME}.app"

rm -rf "${APP_BUNDLE}"
mkdir -p "${APP_BUNDLE}/Contents/MacOS"
mkdir -p "${APP_BUNDLE}/Contents/Resources"
cp "${BUILD_BIN}" "${APP_BUNDLE}/Contents/MacOS/${BIN_NAME}"
cp Info.plist "${APP_BUNDLE}/Contents/Info.plist"
cp Resources/AppIcon.icns "${APP_BUNDLE}/Contents/Resources/AppIcon.icns"

for bundle in .build/debug/*.bundle; do
  [ -d "$bundle" ] && cp -R "$bundle" "${APP_BUNDLE}/Contents/Resources/"
done

echo "Bundled: ${APP_BUNDLE}"
