"Event metadata file path: $Env:GITHUB_EVENT_PATH`n"
$DATA = Get-Content -Path $Env:GITHUB_EVENT_PATH
Write-Host $DATA
$JSON = $DATA | ConvertFrom-Json
Write-Host $JSON