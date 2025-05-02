#!/usr/bin/env bash

set -e
set -o pipefail

GODOT_VERSION_NUMBER="4.3"
GODOT_VERSION_STABILITY="stable"
GODOT_VERSION="${GODOT_VERSION_NUMBER}-${GODOT_VERSION_STABILITY}"
OS="linux"
ARCH="x86_64"
OUTPUT_FILE_PREFIX="Godot_v${GODOT_VERSION}_${OS}.${ARCH}"
OUTPUT_FILE_ZIP="${OUTPUT_FILE_PREFIX}.zip"

EXPORT_TEMPLATES_URL="https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_export_templates.tpz"
ENGINE_DOWNLOAD_URL="https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_${OS}.${ARCH}.zip"

wget -nv -O "${OUTPUT_FILE_ZIP}" "${ENGINE_DOWNLOAD_URL}"
unzip "${OUTPUT_FILE_ZIP}"
rm "${OUTPUT_FILE_ZIP}"
mv "${OUTPUT_FILE_PREFIX}" godot
chmod +x ./godot

wget -nv -O "export_templates.tpz" "${EXPORT_TEMPLATES_URL}"
unzip "export_templates.tpz"
rm "export_templates.tpz"
echo ".local/share/godot/export_templates/${GODOT_VERSION_NUMBER}.${GODOT_VERSION_STABILITY}" > export_templates_path.txt