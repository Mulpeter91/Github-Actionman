"`nThe owner and repository name."
"GITHUB_REPOSITORY: '$Env:GITHUB_REPOSITORY'`n"

"The commit SHA that triggered the workflow."
"GITHUB_SHA: '$Env:GITHUB_SHA'`n"

"The job id you assigned to the current job."
"GITHUB_JOB: '$Env:GITHUB_JOB'`n"

"A unique number for each workflow run within a repository. This number does not change if you re-run the workflow run."
"GITHUB_RUN_ID: '$Env:GITHUB_RUN_ID'`n"

"An unique number for each time the same workflow run again. Starts at 1 and increments by 1."
"GITHUB_RUN_NUMBER: '$Env:GITHUB_RUN_NUMBER'`n"

"The name of the runner executing the job."
"RUNNER_NAME: '$Env:RUNNER_NAME'`n"

"I love a pint of $Env:BEST_PINT with a glass of $Env:BEST_WHISKEY and end the night on a $Env:BEST_COCKTAIL."

$DATA = Get-Content -Path $Env:GITHUB_EVENT_PATH
$JSON = $DATA | ConvertFrom-Json
Write-Host $JSON

"Test"