"The owner and repository name."
"GITHUB_REPOSITORY: '$Env:GITHUB_REPOSITORY'`n"

"The name of the event that triggered the workflow."
"GITHUB_EVENT_NAME: '$Env:GITHUB_EVENT_NAME'`n"

"The branch or tag ref that triggered the workflow run. For branches this is the format refs/heads/<branch_name>, and for tags it is refs/tags/<tag_name>. This variable is only set if a branch or tag is available for the event type."
"GITHUB_REF: '$Env:GITHUB_REF'`n"

"The commit SHA that triggered the workflow."
"GITHUB_SHA: '$Env:GITHUB_SHA'`n"

"The job id you assigned to the current job."
"GITHUB_JOB: '$Env:GITHUB_JOB'`n"

"A unique number for each workflow run within a repository. This number does not change if you re-run the workflow run.`n"
"GITHUB_RUN_ID: '$Env:GITHUB_RUN_ID'`n"

"A unique number for each run of a particular workflow in a repository. This number begins at 1 for the workflow's first run, and increments with each new run. This number does not change if you re-run the workflow run."
"GITHUB_RUN_NUMBER: '$Env:GITHUB_RUN_NUMBER'`n"

"The name of the runner executing the job.`n"
"RUNNER_NAME: '$Env:RUNNER_NAME'`n"