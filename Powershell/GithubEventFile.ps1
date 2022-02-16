"Event metadata file path: $Env:GITHUB_EVENT_PATH`n"
"File Contents:"
$EVENT_FILE = Get-Content -Path $Env:GITHUB_EVENT_PATH
Write-Host $EVENT_FILE

$EVENT_JSON = $EVENT_FILE | ConvertFrom-Json
"`nSample selectors"
Write-Host "OBJECT.head_commit.author.username:" $EVENT_JSON.head_commit.author.username
Write-Host "OBJECT.head_commit.url:" $EVENT_JSON.head_commit.url