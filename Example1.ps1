Param (
    [Parameter()]
    [string]$Hostname = 'Empty',
    [Parameter()]
    [string]$HostIp = 'Empty',
    [Parameter()]
    [string]$Manager = 'Empty'
)

"Hello World! From, Powershell \n"

"This is a GitHub JobId: $Env:GITHUB_JOB"

"This is a Workflow Unique Id: $Env:GITHUB_RUN_ID$Env:GITHUB_RUN_ATTEMPT"

"Passed Hostname: $Hostname"

"Passed Host IP: $HostIp"

"Passed Manager: $Manager"