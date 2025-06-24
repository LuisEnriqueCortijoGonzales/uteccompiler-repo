Write-Output "=== 🚀 UtecCompiler Auto-Build Installer for Windows by Luis and ChatGPT ==="

# 1️⃣ Verifica y instala Git si no está
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Output "🔑 Git not found — Installing Git via winget..."
    winget install -e --id Git.Git
} else {
    Write-Output "✅ Git is already installed."
}

# 2️⃣ Verifica y instala MinGW si no está
if (!(Get-Command g++ -ErrorAction SilentlyContinue)) {
    Write-Output "🔑 g++ not found — Installing MSYS2 (which includes MinGW) via winget..."
    winget install -e --id MSYS2.MSYS2
    Write-Output "👉 After installation, open MSYS2 shell and run:"
    Write-Output "    pacman -Syu"
    Write-Output "    pacman -S mingw-w64-x86_64-gcc"
    Write-Output "⚠️ Please restart your terminal or ensure MinGW bin path is added to PATH."
    Write-Output "⏹️  Exiting installer so you can complete MSYS2 setup."
    exit 1
} else {
    Write-Output "✅ g++ is already installed."
}

# 3️⃣ Crear carpeta de trabajo
$workdir = "$env:USERPROFILE\uteccompiler-build"
New-Item -ItemType Directory -Force -Path $workdir
Set-Location $workdir

# 4️⃣ Clonar el repositorio de código fuente
Write-Output "=== ⏬ Cloning source code..."
git clone https://github.com/LuisEnriqueCortijoGonzales/uteccompiler-repo-source.git .

# 5️⃣ Compilar los ejecutables
Write-Output "=== ⚙️ Compiling UtecC..."
g++ main.cpp parser.cpp scanner.cpp token.cpp visitor.cpp exp.cpp -o UtecC.exe

Write-Output "=== ⚙️ Compiling UtecCop..."
g++ main.cpp parser.cpp scanner.cpp token.cpp visitor.cpp exp.cpp -o UtecCop.exe

# 6️⃣ Mover a una carpeta en PATH
$bin = "$env:USERPROFILE\bin"
New-Item -ItemType Directory -Force -Path $bin
Move-Item UtecC.exe $bin -Force
Move-Item UtecCop.exe $bin -Force

# 7️⃣ Añadir $bin a la PATH del usuario (si no está)
$oldPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if ($oldPath -notlike "*$bin*") {
    Write-Output "🔑 Adding $bin to your user PATH..."
    $newPath = $oldPath + ";$bin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::User)
    Write-Output "✅ $bin has been added to your user PATH."
} else {
    Write-Output "✅ $bin is already in your PATH."
}

# 8️⃣ Limpiar
Remove-Item $workdir -Recurse -Force

Write-Output "✅ Done!"
