"Event metadata file path: $Env:GITHUB_EVENT_PATH`n"
$FILE_DATA = Get-Content -Path $Env:GITHUB_EVENT_PATH

Write-Host $FILE_DATA
$JSON = $FILE_DATA | ConvertFrom-Json
Write-Host "TEST" $JSON
"Sample output nodes:"
"head_commit.author.username:" $JSON.head_commit.author.username