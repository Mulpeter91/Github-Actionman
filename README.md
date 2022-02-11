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



# Powershell


# Example 1 - Hello World

Some actions allow for configuration by way of passing parameters. See action repo documentation for more information.    
You are also not limited to using only the official github actions repo. Include the use keyword followed by an repo
set up with a predefined action repo (includes an action.yaml in the root). Examples include Google's own actions: https://github.com/google-github-actions



