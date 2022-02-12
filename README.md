# Github Actionman

Purpose of this repo is to experiment with github actions in the execution of powershell scripts

# Introduction

Github actions is a platform to automate developer workflows.

While CI/CD is often used to convey its utility, it is just one of many possible workflows.

History of Actions: github is home to many open source projects which are open to community contributions. 
This creates a lot of organisation tasks: labeling, assignment of tasks, pull requests, prs, testing, documentation of releases etc
The bigger and more contributors there are, you don't as the admin want to spend your time fixing all this.

In a nutshell, when an event occurs in or to your repository, an automatic ACTION is executed in response.
events: pr created, issue raised, pr merged, contributor joins.

Actions listen to these events and trigger a workflow in response. For example, if an issue is raised you
may want to sort it, label it, assign it or attempt to reproduce it. These actions are collectively is a workflow.

# Github CI/CD

Still the most common is CI/CD: You commit your code, the build starts, tests your code, builds it into an artefact,
then pushes it to some storage, then deploys to a server

What's the advantage of another platform to support CI/CD? well for those who store their code on github, it's one
less 3rd party tool. 

The setup of actions is incredibly easy and much more simple relative to competing tools like Jenkins. 

One of the ways this is made easy is that actions can come with integration with the dependant technologies you need

# Hosting

Github actions are executed on github servers, but you can host your own if you choose. It is important to note that jobs listed
within a workflow are run on different github servers. By default the jobs in a workflow run in parallel but in the event you
want them to wait you can use the 'needs' keyword in dependent jobs

# Powershell


# Example 1 - Hello World

Some actions allow for configuration by way of passing parameters. See action repo documentation for more information.    
You are also not limited to using only the official github actions repo. Include the use keyword followed by an repo
set up with a predefined action repo (includes an action.yaml in the root). Examples include Google's own actions: https://github.com/google-github-actions


https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows
https://github.com/google-github-actions

# Example 2 - Environment Variables

To set a custom environment variable, you must define it in the workflow file. The scope of a custom environment variable is limited to the element in which it is defined. You can define environment variables that are scoped for:

The entire workflow, by using env at the top level of the workflow file.
The contents of a job within a workflow, by using jobs.<job_id>.env.
A specific step within a job, by using jobs.<job_id>.steps[*].env.

https://docs.github.com/en/actions/learn-github-actions/environment-variables

Because environment variable interpolation is done after a workflow job is sent to a runner machine, you must use the appropriate syntax for the shell that's used on the runner. In this example, the workflow specifies ubuntu-latest. By default, Linux runners use the bash shell, so you must use the syntax $NAME. If the workflow specified a Windows runner, you would use the syntax for PowerShell, $env:NAME.
But since we're specifying powershell core we use $env:Name

run: notice that $BEST_COCKTAIL is not listed, while the other two are. This is because $BEST_COCKTAIL is bounded to that step.