# Warn if execution policy is restricted
if ((Get-ExecutionPolicy) -eq "Restricted") {
    Write-Warning "ExecutionPolicy is Restricted. Please run the following command in a PowerShell with admin privileges:"
    Write-Host "Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force"
    exit
}

# Create virtual environment
pip install virtualenv
python -m virtualenv venv_web

# Activate virtual environment
.\venv_web\Scripts\activate

# Install required Python packages
pip install -r requirements.txt

# Run Python web service in a new terminal window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd $(Get-Location); .\venv_web\Scripts\activate; python .\myapp\manage.py runserver"

# Try to find Tomcat webapps directory in common locations
$possibleTomcatPaths = @(
    "$env:ProgramFiles\Apache Software Foundation\Tomcat 11.0\webapps",
    "$env:ProgramFiles\Apache Software Foundation\Tomcat 10.0\webapps",
    "$env:ProgramFiles\Apache Software Foundation\Tomcat 9.0\webapps",
    "$env:ProgramFiles\Apache Tomcat\webapps",
    "$env:LOCALAPPDATA\Programs\Apache Software Foundation\Tomcat\webapps"
)

$foundTomcatPath = $null
foreach ($path in $possibleTomcatPaths) {
    if (Test-Path $path) {
        $foundTomcatPath = $path
        break
    }
}

if ($foundTomcatPath) {
    # Copy servlet folder to detected Tomcat webapps directory
    Copy-Item -Path ".\servlet\servlet-web-2\" -Destination $foundTomcatPath -Recurse -Force
    Write-Host "Servlet copied to: $foundTomcatPath"
} else {
    Write-Warning "Tomcat webapps folder not found. Please copy the servlet manually."
}

# Try to launch MongoDB Compass from Start Menu shortcut
$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\MongoDB Inc\MongoDB Compass.lnk"

if (Test-Path $shortcutPath) {
    Start-Process $shortcutPath
    Write-Host "MongoDB Compass launched from shortcut."
} else {
    Write-Warning "MongoDB Compass shortcut not found at expected location. Please open it manually."
}


# Wait a few seconds to allow MongoDB Compass to open
Start-Sleep -Seconds 10

# Open migration URL in default web browser
Start-Process "http://localhost:8080/servlet-web-2/transfer"
