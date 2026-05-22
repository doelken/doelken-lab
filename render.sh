#!/bin/bash

echo "🧹 Cleaning docs/..."
rm -rf docs/

echo "📖 Rendering..."
quarto render

echo "🔗 Restoring CNAME..."
echo "doelkenlab.de" > docs/CNAME

echo "✅ Done!"