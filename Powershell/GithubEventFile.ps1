"Event log path: $Env:GITHUB_EVENT_PATH"
$DATA = Get-Content -Path $Env:GITHUB_EVENT_PATH
$JSON = $DATA | ConvertFrom-Json
Write-Host $JSON