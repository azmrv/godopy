rm internal-packages/godot/*.cpp
rm internal-packages/godot/core/*.cpp
rm internal-packages/godot/bindings/*.cpp
. buildenv/bin/activate
pip install ./internal-packages