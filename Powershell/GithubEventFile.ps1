"Event metadata file path: $Env:GITHUB_EVENT_PATH`n"
$EVENT_FILE = Get-Content -Path $Env:GITHUB_EVENT_PATH

$EVENT_JSON = $EVENT_FILE | ConvertFrom-Json
Write-Host $EVENT_JSON
"Sample selectors"
Write-Host "`nOBJECT.head_commit.author.username:" $EVENT_JSON.head_commit.author.username
Write-Host "OBJECT.head_commit.url:" $EVENT_JSON.head_commit.url