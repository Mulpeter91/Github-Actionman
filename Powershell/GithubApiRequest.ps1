"`nThis will return a list of all open pull requests.`n"
$URI = "https://api.github.com/repos/$Env:GITHUB_REPOSITORY/pulls"
$response = Invoke-WebRequest -Uri $URI -Method Get -TimeoutSec 480
Write-Host $URI
Write-Host $response

"`n`nThis will return a specific open pull request.`n"
$ID = $Env:GITHUB_REF_NAME -replace "/.*"
$URI = "https://api.github.com/repos/$Env:GITHUB_REPOSITORY/pull/$ID"
$response = Invoke-WebRequest -Uri $URI -Method Get -TimeoutSec 480
Write-Host $URI
Write-Host $response