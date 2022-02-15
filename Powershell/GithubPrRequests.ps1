"`nThis will return a list of all open pull requests.`n"
$URI = "https://api.github.com/repos/$Env:GITHUB_REPOSITORY/pulls"
Write-Host $URI
$response = Invoke-WebRequest -Uri $URI -Method Get -TimeoutSec 480
Write-Host $response

"`n`nThis will return all pull requests of a specified state.`n"
$ID = $Env:GITHUB_REF_NAME -replace "/.*"
$URI = "https://api.github.com/repos/$Env:GITHUB_REPOSITORY/pulls?state=$Env:PR_STATE"
Write-Host $URI
$response = Invoke-WebRequest -Uri $URI -Method Get -TimeoutSec 480
Write-Host $response

"`n`nThis will return a specific pull request.`n"
$ID = $Env:GITHUB_REF_NAME -replace "/.*"
$URI = "https://api.github.com/repos/$Env:GITHUB_REPOSITORY/pulls/$ID"
Write-Host $URI
$response = Invoke-WebRequest -Uri $URI -Method Get -TimeoutSec 480
Write-Host $response

$JSON_OBJECT = (Get-Content $response -Raw) | ConvertFrom-Json
Write-Host "`n`n" $JSON_OBJECT.html_url
