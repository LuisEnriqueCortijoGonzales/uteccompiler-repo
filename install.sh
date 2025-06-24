#!/bin/bash

echo "=== UtecCompiler Installer ==="

# Agrega el repo a sources.list.d
echo "deb [trusted=yes] https://luisenriquecortijogonzales.github.io/uteccompiler-repo stable main" | sudo tee /etc/apt/sources.list.d/uteccompiler.list

# Actualiza índices
echo "=== Updating package lists..."
sudo apt update

# Instala el compilador
echo "=== Installing uteccompiler..."
sudo apt install -y uteccompiler

echo "✅ Done! You can now run UtecC and UtecCop from the terminal."
