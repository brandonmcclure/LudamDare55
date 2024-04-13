godot --export-release "Web" --headless bin/web/index.html 
if [ ! -e bin/web/index.html ]; then
exit 1
fi