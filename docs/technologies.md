# Technologies  

As an open-source project, this application would not be possible without the labor of countless others. We 
try to keep this file up-to-date with all of the tools and technologies we use as a small shout-out and to keep
track of what we're using and why.

## Core App Technologies
_These form the foundation of our application_

#### Ruby on Rails: Web Application Framework 

Server-side application framework written in Ruby which provides the major building-blocks for the ASPC website. Without 
Rails, this site would simply not be possible!

#### Bulma: CSS Framework

An amazing, modern frontend framework streamlines our UI work by providing customizable style templates.

#### VirtualBox: Virtual Machine

The virtual machine managed by Vagrant which provides our developers a local environment where they can access 
their local version of the ASPC website and database in the same environment as the site running on production.

#### Vagrant: Virtual Machine Manager (Depreciated)

This command-line tool provisions and manages virtual machines, meaning that it can start, refresh, and stop the 
local environment that we use for development and ensure consistency across our many development machines and production
environment.

#### Docker
This tool allows us to create an isolated container which allows development in a consistent environment regardless of 
the host OS the developer is using.

#### PostgresQL 

The database technology we use to persist our application data. 

#### Capistrano

Deployment tool responsible for releasing production-ready code to the public.

#### RSpec

Testing framework so that way may ensure features and functionality work as expected

## Integrations & Product Management Tools
_These ensure processes around the code are (and stay) standardized and up to date._

#### CircleCI

Continuously builds our project and runs tests to ensure code is ready to release

#### Coveralls

Tracks and monitors our testing code coverage

#### Dependabot

Automatically keeps our dependencies up to date and secure

#### ImgBot

Losslessly compresses images to keep our asset footprint as lean as possible

#### Waffle.io + GitHub Project Boards

Project tracking and task assignment for our team.

#### Uptime Robot: Server Status

Alerts us when one of our sites has crashed. 
