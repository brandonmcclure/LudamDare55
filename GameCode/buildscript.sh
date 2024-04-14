#!/bin/bash
set -e
godot --export-release "Web" --headless bin/web/index.html --verbose
if [ ! -e bin/web/index.html ]; then
exit 1
fi