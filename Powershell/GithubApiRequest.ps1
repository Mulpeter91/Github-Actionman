$response = Invoke-WebRequest -Uri "https://api.github.com/repos/$Env:GITHUB_REPOSITORY/pulls" -Method Get -TimeoutSec 480
Write-Host $response