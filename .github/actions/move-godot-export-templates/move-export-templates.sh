#!/bin/bash

# Assumes install-godot has already run, which populates the export templates path file.
export_template_path="$HOME/$(cat export_templates_path.txt)"

mkdir -p "${export_template_path}"
mv templates/* "${export_template_path}/."
rm -rf templates