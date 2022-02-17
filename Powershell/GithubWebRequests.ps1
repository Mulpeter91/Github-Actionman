"`nThis will return a list of all open pull requests:"
$URI = "https://api.github.com/repos/$Env:GITHUB_REPOSITORY/pulls`n"
Write-Host $URI
$RESPONSE = Invoke-WebRequest -Uri $URI -Method Get -TimeoutSec 480
Write-Host $RESPONSE

"`n`nThis will return all pull requests of a specified state:"
$URI = "https://api.github.com/repos/$Env:GITHUB_REPOSITORY/pulls?state=$Env:PR_STATE`n"
Write-Host $URI

"`n`nThis will return a specific pull request:"
$PR_NUMBER = $Env:GITHUB_REF_NAME -replace "/.*" # <- You can also get the PR number from the event file.
$URI = "https://api.github.com/repos/$Env:GITHUB_REPOSITORY/pulls/$PR_NUMBER`n"
Write-Host $URI
$RESPONSE = Invoke-WebRequest -Uri $URI -Method Get -TimeoutSec 480
Write-Host $RESPONSE

"`n`nAccessing variables from the object: "
$JSON_OBJECT = $RESPONSE | ConvertFrom-Json
"HTML URL:" $JSON_OBJECT.html_url
"TITLE: ${ $JSON_OBJECT.title}"
Write-Host "BODY:" $JSON_OBJECT.body
Write-Host "USER:" $JSON_OBJECT.user.login
Write-Host "REQUESTED REVIEWERS:" $JSON_OBJECT.requested_reviewers
Write-Host "MERGE_COMMIT_SHA:" $JSON_OBJECT.merge_commit_sha
