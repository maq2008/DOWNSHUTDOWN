$ErrorActionPreference = "SilentlyContinue"
$gitPath = "C:\Program Files\Git\bin\git.exe"
Set-Alias -Name git -Value $gitPath

Set-Location "C:\Users\Admin\Downloads\downshutdown"
git config --global user.email "auto@shutdown.local"
git config --global user.name "Auto Shutdown"
git add .
git commit -m "Initial commit - DOWNSHUTDOWN"

Write-Host "Commit done. Ready to push to GitHub."
Write-Host "To create GitHub repo, I need your GitHub credentials."
Write-Host ""
Write-Host "Please provide:"
Write-Host "1. GitHub Username"
Write-Host "2. GitHub Personal Access Token (create at: https://github.com/settings/tokens)"
Write-Host ""
Write-Host "Or manually run these commands after entering your token:"
Write-Host "git remote add origin https://github.com/YOUR_USERNAME/DOWNSHUTDOWN.git"
Write-Host "git push -u origin master"