"Event metadata file path: $Env:GITHUB_EVENT_PATH`n"
$FILE_DATA = Get-Content -Path $Env:GITHUB_EVENT_PATH

Write-Host $FILE_DATA "`n`n"
$JSON = $DATA | ConvertFrom-Json
"Sample output nodes:"
"head_commit.author.username:" $JSON.head_commit.author.username