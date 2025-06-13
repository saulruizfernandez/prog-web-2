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

# Copy servlet folder to Tomcat webapps directory
$tomcatPath = "C:\Program Files\Apache Software Foundation\Tomcat 11.0\webapps"
Copy-Item -Path ".\servlet\servlet-web-2\" -Destination $tomcatPath -Recurse -Force

# Open MongoDB Compass (ensure path is correct or modify if needed)
Start-Process "C:\Program Files\MongoDB Compass\MongoDBCompass.exe"

# Wait a few seconds to allow MongoDB Compass to open
Start-Sleep -Seconds 10

# Open migration URL in default web browser
Start-Process "http://localhost:8080/servlet-web-2/transfer"
