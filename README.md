![Article Banner](https://github.com/Mulpeter91/Github-Actionman/blob/main/ReadMeImages/Banner.png)

# Getting Started with Github Action Workflows

This article gives a brief introduction to the concepts and syntax of github actions. While the 
[official documentation](https://docs.github.com/en/actions) of github actions is comprehensive, the aim of this article is to help avoid those early learning mistakes.

## Context

Github actions is a platform to automate developer workflows. It was built to reduce the organisational 
burden attached to large open-source community driven repositories. This burden would manifest in the form 
of hundreds, if not thousands, of contributors, branches, pull requests, merges as well as testing, labelling,
creating release documentation and many other tasks or events.

The purpose of an action is to listen to these events and trigger a workflow in response. For example, if a contributor raises an issue, you
may want to sort it, label it, and assign it automatically. A workflow is a `.yml` or `.yaml` file with a set of 
instructions you define.

While CI/CD is often used to convey its utility, it is just one of many possible workflows you can create to serve
your needs. The examples in this article are simple workflows created merely to introduce some of the basic concepts.

1. [Executing Shell Commands](#example-1)
2. [Accessing environment variables](#example-2)
3. [Calling local composite action](#example-3)
4. [Setting & Passing Variables](#example-4)

## 1. <a id="example-1"></a>Executing Shell Commands 🐚

The first example below is a very basic workflow executing different commands in their native shells. The point of this example 
is to illustrate the role of the `run-on` and `shell` instructions. A workflow refers to all the instructions within the file, 
which is comprised of one or more `jobs`, which in turn is comprised of one or more `steps`.

Each `job` listed within a workflow is executed concurrently on a different github server, but you can choose to host them yourself.
The significance of this means you need to specify which operating system you want your `job` to run on by using the `run-on` keyword.
This can include various versions of windows, macOS, ubuntu or even being self-hosted.

If for example all your steps within a job ran powershell commands or scripts, you could `run-on: windows-latest` and call it job done as
powershell would be understood by that operating system. But let's say you needed to run a one off Zshell script in the same job, here the `shell`
keyword can allow you to override the shell of the specified OS by specifying the correct shell language.

Below is an example of 'Hello World' being printed to the console in `powershell`, `bash`, `zshell` and even `python` , which are all being 
run on a `windows` github server. Github also accepts `powershell`, `pwsh` (powershell core) and `cmd` when overriding for Windows commands.
See the code example for more useful information in the comments and follow all links to source file.

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

## 2. <a id="example-2"></a>Accessing Environment Variables 🌱

The following example illustrates how you can read `environment variables`. There are two kinds of variables, 
those provided by github which use protected names and can be found in the [documentation](https://docs.github.com/en/actions/learn-github-actions/environment-variables),
and custom variables you can set yourself throughout your workflow.

Another significant feature of the `workflow`, `job` and `step` relationship is how custom variables are scoped. 
Declared variables within the workflow using the keyword `env` follow an access hierarchy and can only be accessed within the element they were defined. Those variables declared at the highest
`workflow` level can be accessed by all `jobs` and `steps`. Variables declared within a `job` can only be used by steps within that job and if
declared inside a `step` they can only be used by that step.

In the below workflow example you can see that 3 custom variables are declared at different levels: 
`BEST_PINT`, `BEST_WHISKEY` and `BEST_COCKTAIL`. In the `Print Variables to Script` step a [script](https://github.com/Mulpeter91/Github-Actionman/blob/main/Powershell/GithubEnvVariables.ps1) 
is executed to print these variables to the console along with a sample of various set github environment variables.

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
A useful command to inspect available environment variables within a step is `run: env`. Notice that the below output does not contain `BEST_COCKTAIL` because it was defined and scoped to the previous step.
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


You must remember to use the correct syntax for referencing variables in your target shell. For example, Windows runners would required the format `$env:NAME`
while the Linux runners using bash shell would use `$NAME`.

## 3. <a id="example-3"></a>Calling local Composite Action ⚙️

[Composite actions](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action) 
are a specific type of workflow file which are designed to abstract out and reuse a set of instructions for one or more requesting workflows.
They are typically stored in their own repositories, such as [Github's own shared actions](https://github.com/actions) 
or [Google's integration actions](https://github.com/google-github-actions), but they can also be stored and executed in the same repository.

A step utilises the `uses` keyword when executing a `composite action`. In the below example you will notice two steps
each using a composite action, the first is using github's shared `actions/checkout@v2` and the other is using our local `composite action`.

Composite actions dependent on targeted releases to know which version of the code to execute. In the case of `checkout@v2` this is referencing release `v2`
in the `checkout` repository. You need to checkout your code in order to build it, test it or in our case execute composite actions.

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
The `composite action` file requires a `name` and `description` field with an optional `author` field.
The run also needs to add `using: 'composite'` before executing its steps.

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

Another important point regarding `composite actions` is that they must be defined inside a file called either
`action.yml` or `action.yaml`. It is recommended that if you have multiple composite actions in the same repo
that you house them in their own directories within the `.github` directory. While these directories can contain other
files such as docker files, they must contain **one** `action` file. See working [repo](https://github.com/Mulpeter91/Github-Actionman/tree/main/.github/actions)
for an example.

## 4. <a id="example-4"></a>Setting and Passing Variables 🤾

The below `step` examples are all run on the same `workflow` file and combine parts of the previous code with
the added fun of setting variables from outside the `yml` file and passing variables around the workflow.

### 4.1 Passing Parameters to Composite Action

In the below example we are using a `composite action` much like example 3 but with `input` parameters. 
The `step` passing these named parameters to the action with the `with` keyword and `<variable>` name, in this case 'message'.

[**Job 1 / Step 1**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/workflows/ex4-passing-variables.yml)
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
The composite action lists its parameters with the `inputs` keyword. Parameters can be `required: true` or `false`, include
a `description` and a `default` value if no value is passed. In our case, a `message` value is sent but a `version` value is not.

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

### 4.2 Set Variables from Environment File

The following example combines a parameterised composite action with reading the contents of an 
`.env` file into the environment variables for access by the workflow.

[**Job 1 / Step 2**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/workflows/ex4-passing-variables.yml)
```yaml
      #Example 4.2
      - name: Set variables from environment file
        uses: ./.github/actions/read-env-file
        with:
          filePath: ./.github/variables/variables.env
```
Using `>> $Env:GITHUB_ENV` instructs github to read the variable into the environment variable dictionary.

[**Composite Action**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/actions/read-env-file/action.yml)
```yaml
name: Read Env Variables from file
description: Reads environment variables from a passed .env file.
author: Robert Mulpeter @Mulpeter91

inputs:
  filePath:
    required: true
    description: "File path to variable file."
    default: ./.github/variables*

runs:
  using: "composite"
  steps:
    - run: |
        Get-Content ${{ inputs.filePath }} >> $Env:GITHUB_ENV   # <- Adding directly $Env:GITHUB_ENV saves at the workflow level
      shell: pwsh
```

It is advised to keep all variable related files within the `.github` directory.

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

### 4.3 Set Variables from Powershell File

The following example achieves the same outcome of example 4.2 but adds environment variables
by executing a `powershell` script directly.

[**Job 1 / Step 3**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/workflows/ex4-passing-variables.yml)
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

### 4.4 Pass Variable to Dependant Job
<div style="color:red"> 4.4 WORK IN PROGRESS & INCOMPLETE</div>

We previously noted that `jobs` are run concurrently by default and that variables are scoped to 
the element they are defined in. The following example illustrates how you can enforce a dependency between jobs 
to have them run consecutively to each other by using the `needs` array and pass a variable from the initial 
job to the `dependent job` by using the `xxx` keyword.

[**Job 2 / Step 1**](https://github.com/Mulpeter91/Github-Actionman/blob/main/.github/workflows/ex4-passing-variables.yml)
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
Work in Progress
```

## Conclusion

The purpose of this article and these examples was to give you an introduction to basic concepts
and syntax in order to continue learning github actions with a clearer vision of the platform. 
But this is just the tip of the iceberg. Github actions are capable of far more precise workflows
with the use of more complex syntax.