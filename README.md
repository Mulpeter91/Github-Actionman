# Getting Started with Github Action Workflows

This article gives a brief introduction to the concepts and syntax of github actions. While the 
official documentation of github actions is comprehensive, the aim of this article is to help avoid those early learning mistakes.

##Some Context

Github actions is a platform to automate developer workflows. It was built to reduce the organisational 
burden attached to large open-source community driven repositories. This burden would manifest in the form 
of hundreds, if not thousands, of contributors, branches, pull requests, merges as well as testing, labelling,
creating release documentation and many other tasks or events.

The purpose of an action is to listen to these events and trigger a workflow in response. For example, if a contributor raises an issue, you
may want to sort it, label it, and assign it automatically. A workflow is a `.yml` or `.yaml` file with a set of 
instructions you define.

While CI/CD is often used to convey its utility, it is just one of many possible workflows you can create to serve
your needs. The examples in this article are simple workflows created merely to introduce some of the basic concepts.

1. Executing hello world in shell
2. Accessing environment variables
3. Calling local composite action
4. Setting & Passing Variables

##1. Executing Hello World in Shell

Github actions are executed on github servers, but you can host your own if you choose. It is important to note that jobs listed
within a workflow are run on different github servers. By default the jobs in a workflow run in parallel but in the event you
want them to wait you can use the 'needs' keyword in dependent jobs

[**Workflow**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/workflows/ex1-execute-scripts.yml)
```yaml
name: 1 - Run Hello Worlds scripts              # <- Workflow name.

on:                                             # <- The trigger definition block.
  push:                                         # <- An event to trigger the action, of type push.
    branches: [                                 # <- Target Branches. Accepts an array.
      main,
      another-branch
    ]

jobs:                                           # <- The execution of work block.
  Job-Identifier:                               # <- Job ID. Contains related action steps.
    name: Executing Hello World Script          # <- Job Name.
    runs-on: windows-latest                     # <- Tells the server which OS to run on. Can also be windows, macOS, or even self-hosted.      

    steps:                                      # <- Step definitions.
      - uses: actions/checkout@v2               # <- Use keyword selects an action. Actions/ path in github is where common actions are predefined.

      - name: Printing Powershell               # <- Optional step name, but advised.                       
        run: ./Powershell/HelloWorld.ps1        # <- Run keyword executes a command. In this case a powershell script.

      - name: Printing Bash
        shell: bash                             # <- Overrides the default shell language of your specified server. 
        run: ./Bash/HelloWorld.sh

      - name: Printing ZShell
        shell: sh
        run: ./Zshell/HelloWorld.zsh

      - name: Printing Python
        shell: python
        run: exec(open('./Python/HelloWorld.py').read())
```
[**Console Output**](https://github.com/Mulpeter91/Github-Actionman/runs/5173467514?check_suite_focus=true)
```
Run ./Powershell/HelloWorld.ps1
Hello World from Powershell!

Run ./Bash/HelloWorld.sh
Hello World from Bash!

Run ./Zshell/HelloWorld.zsh
hello world from Zshell!

Run exec(open('./Python/HelloWorld.py').read())
Hello World from Python!
```


https://dev.to/pwd9000/github-actions-all-the-shells-581h

Some actions allow for configuration by way of passing parameters. See action repo documentation for more information.    
You are also not limited to using only the official github actions repo. Include the use keyword followed by an repo
set up with a predefined action repo (includes an action.yaml in the root). Examples include Google's own actions: https://github.com/google-github-actions


https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows
https://github.com/google-github-actions

pwsh In this case it is PowerShell Core, which defaults to UTF-8.

##2. Accessing Environment Variables

[**Workflow**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/workflows/ex2-access-variables.yml)
```yaml
name: 2 - Access Github Environment Variables

on:
  push:
    branches: [
        main,
        another-branch
    ]

env:
  BEST_PINT: Guinness                             # <- Custom Env variables are set within the workflow file.
                                                  # <- High order variables are scoped to everything within the workflow.

jobs:
  Job-Identifier-Sample:
    name: Printing Github Environment Variables
    runs-on: windows-latest
    env:
      BEST_WHISKEY: Midleton                      # <- Scoped to this job and subsequent steps.         

    steps:
      - uses: actions/checkout@v2
      
      - name: Print Variables to Script
        run: ./Powershell/GithubEnvVariables.ps1
        env:
          BEST_COCKTAIL: Whiskey Sour              # <- Scoped to this step only.

      - name: Inspect Environment Variables
        run: env                                   # <- Prints to output the available variables to this step. 
```
[**Console Output**](https://github.com/Mulpeter91/Github-Actionman/runs/5173467512?check_suite_focus=true)
```
The owner and repository name.
GITHUB_REPOSITORY: 'Mulpeter91/Github-Actionman'

The commit SHA that triggered the workflow.
GITHUB_SHA: '321d557ec2d724d2c6aaf056b14859ea8468051e'

The job id you assigned to the current job.
GITHUB_JOB: 'Job-Identifier-Sample'

A unique number for each workflow run within a repository. This number does not change if you re-run the workflow run.
GITHUB_RUN_ID: '1836698654'

An unique number for each time the same workflow is run again. Starts at 1 and increments by 1.
GITHUB_RUN_NUMBER: '18'

The name of the runner executing the job.
RUNNER_NAME: 'GitHub Actions 4'

I love a pint of Guinness with a glass of Midleton and end the night on a Whiskey Sour.
```
```
...

APPDATA=C:\Users\runneradmin\AppData\Roaming
AZURE_EXTENSION_DIR=C:\Program Files\Common Files\AzureCliExtensionDirectory
BEST_PINT=Guinness
BEST_WHISKEY=Midleton
CABAL_DIR=C:\cabal
ChocolateyInstall=C:\ProgramData\chocolatey

...
```

To set a custom environment variable, you must define it in the workflow file. The scope of a custom environment variable is limited to the element in which it is defined. You can define environment variables that are scoped for:

The entire workflow, by using env at the top level of the workflow file.
The contents of a job within a workflow, by using jobs.<job_id>.env.
A specific step within a job, by using jobs.<job_id>.steps[*].env.

https://docs.github.com/en/actions/learn-github-actions/environment-variables

Because environment variable interpolation is done after a workflow job is sent to a runner machine, you must use the appropriate syntax for the shell that's used on the runner. In this example, the workflow specifies ubuntu-latest. By default, Linux runners use the bash shell, so you must use the syntax $NAME. If the workflow specified a Windows runner, you would use the syntax for PowerShell, $env:NAME.
But since we're specifying powershell core we use $env:Name

run: notice that $BEST_COCKTAIL is not listed, while the other two are. This is because $BEST_COCKTAIL is bounded to that step.

##3. Calling local Composite Action

[**Workflow**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/workflows/ex3-composite-action.yml)
```yaml
name: 3 - Running a local Composite Action

on:
  push:
    branches: [
        main,
        another-branch
    ]

jobs:
  Run-Composite-Action:
    name: Print message from another action
    runs-on: windows-latest

    steps:
      - uses: actions/checkout@v2                 # <- Required to checkout your code in order to access composite actions from with the repo
      - name: Use hello world composite action
        uses: ./.github/actions/hello-world       # <- Use keyword for calling other actions
```
[**Composite Action**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/actions/hello-world/action.yml)
```yaml
name: Print Hello World
description: Prints a Hello World message.
author: Robert Mulpeter @Mulpeter91

runs:
  using: "composite"                # <- Required declaration of a composite action.
  steps:
    - run: Write-Host "Hello World from Composite Action!"
      shell: pwsh
```
[**Console Output**](https://github.com/Mulpeter91/Github-Actionman/runs/5173467513?check_suite_focus=true)
```
Run ./.github/actions/hello-world
Run Write-Host "Hello World from Composite Action!"
Hello World from Composite Action!
```

Each custom action requires its own directory and action.yml to define it.
[link](https://dev.to/jameswallis/using-github-composite-actions-to-make-your-workflows-smaller-and-more-reusable-476l)
https://arinco.com.au/blog/github-actions-share-environment-variables-across-workflows/
https://github.com/lowlighter/metrics/discussions/448

##4. Setting & Passing Variables

###4.1 Passing Parameters to Composite Action

[**Job 1 Step 1**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/workflows/ex4-passing-variables.yml)
```yaml
jobs:
  Create-Variables:
    name: Creating and passing variables
    runs-on: windows-latest

    steps:
      #Example 4.1
      - uses: actions/checkout@v2
      - name: Use print message composite action
        uses: ./.github/actions/print-message
        with:                                 # <- With keyword to signify parameters
          message: "Cobra Kai never dies"     # <- Named parameter in the called action.
```
[**Composite Action**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/actions/print-message/action.yml)
```yaml
name: Print Parameters
description: Prints a message passed from the workflow.
author: Robert Mulpeter @Mulpeter91

inputs:       # <- keyword for defining action parameters.     
  message:
    required: true
    description: "The message to be printed"
  version:
    required: false
    description: "The version."
    default: "🤟🏻"

runs:
  using: "composite"
  steps:
    - run: Write-Host ${{ inputs.message }} ${{ inputs.version }}
      shell: pwsh
```
[**Console Output**](https://github.com/Mulpeter91/Github-Actionman/runs/5173627256?check_suite_focus=true)
```
Run ./.github/actions/print-message
Run Write-Host Cobra Kai never dies 🤟🏻
Cobra Kai never dies 🤟🏻
```

###4.2 Set Variables from Environment File

[**Job 1 Step 2**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/workflows/ex4-passing-variables.yml)
```yaml
      #Example 4.2
      - name: Set variables from environment file
        uses: ./.github/actions/read-env-file
        with:
          filePath: ./.github/variables/variables.env
```
[**Input File**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/variables/variables.env)
```
DOJO_1=Miyagi-Do Karate
```

[**Console Output**](https://github.com/Mulpeter91/Github-Actionman/runs/5173627256?check_suite_focus=true)
```
Run Get-Content ./Powershell/Variables.ps1 >> $Env:GITHUB_ENV
  Get-Content ./Powershell/Variables.ps1 >> $Env:GITHUB_ENV
  shell: C:\Program Files\PowerShell\7\pwsh.EXE -command ". '{0}'"
  env:
    DOJO_1: Miyagi-Do Karate
```

###4.3 Set Variables from Powershell File

[**Job 1 Step 3**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/workflows/ex4-passing-variables.yml)
```yaml
     #Example 4.3
     - name: Set variables from powershell file
       run: Get-Content ./Powershell/Variables.ps1 >> $Env:GITHUB_ENV   
```
[**Input File**](https://github.com/Mulpeter91/Github-Actionman/blob/main/Powershell/Variables.ps1)
```
DOJO_2=Eagle Fang Karate
DOJO_3=Cobra-Kai Karate
```

[**Console Output**](https://github.com/Mulpeter91/Github-Actionman/runs/5173627256?check_suite_focus=true)
```
Run Get-Content ./Powershell/Variables.ps1 >> $Env:GITHUB_ENV
```

###4.4 Pass Variable to Dependant Job (WIP)

[**Job 2 Step 1**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/workflows/ex4-passing-variables.yml)
```yaml
  Obtain-Variables:
    needs: [Create-Variables]       # <- Jobs run concurrently by default. The 'needs' keyword sets dependant jobs.
    name: Reading previous variables
    runs-on: windows-latest

    steps:
      - name: Inspect Environment Variables
        run: env
```
[**Console Output**](https://github.com/Mulpeter91/Github-Actionman/runs/5173627256?check_suite_focus=true)
```
```


https://www.jamescroft.co.uk/setting-github-actions-environment-variables-in-powershell/

https://www.edwardthomson.com/blog/github_actions_15_sharing_data_between_steps.html

This is some text
* point
* point2