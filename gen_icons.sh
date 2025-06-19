#!/bin/bash
# For generate the 'lib/icon_assets.dart' file from using
# chmod +x gen_icons.sh
# ./gen_icons.sh
echo "⚙️  Generating icons..."

dart lib/src/tools/generate_icon_assets.dart

# Checking the return code
if [ $? -eq 0 ]; then
  echo "✅ Ready!"
else
  echo "❌ An error occurred during generation."
fi
