[![CircleCI](https://circleci.com/gh/aspc/aspc-website/tree/master.svg?style=svg)](https://circleci.com/gh/aspc/aspc-website/tree/master)
[![Coverage Status](https://coveralls.io/repos/github/aspc/aspc-website/badge.svg?branch=master)](https://coveralls.io/github/aspc/aspc-website?branch=master)


# ASPC Website 2.0

This repo is intended to be a complete rewrite of [pomonastudents.org](https://pomonastudents.org) (formerly [aspc.pomona.edu](http://aspc.pomona.edu)). The aim of this project is to:
 - Put the content that most people use front and center
 - Redesign the website from the ground up
 - Streamline and trim legacy features

## Development
This repo is run and maintained by the ASPC Software Development Group, but anyone may contribute to this repository!
If you attend Pomona College or any of the other Claremont Colleges and would like to join, please feel free to reach out to us at software@aspc.pomona.edu.

### Getting Up And Running
It's simple to start contributing! We've also provided a more detailed [Getting Started Guide](docs/getting-started.md)
with information about setting up this project to work with an IDE, our core technologies, and more helpful tips.

 1. Clone this repo
 2. Install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
 3. Run `vagrant up` from inside the cloned directory. Follow the prompts, default options are fine. This will handle dependency installation and all that jazz.
 4. Run `vagrant ssh`, `cd /vagrant`, `bundle install`, `yarn install`, and then `rails server -b 0.0.0.0 -p 3000`.
 5. Navigate to [localhost:3000](http://localhost:3000) to see a local copy of this website up and running!

## Contributing
For guidelines of how to contribute to this project, head to [CONTRIBUTING.md](CONTRIBUTING.md)

## License

This project is licensed under the MIT standard license, which may be read at [LICENSE.md](LICENSE.md).

## I have a feature request / There's a problem with the website!

If you're familiar with GitHub, open up a GitHub Issue and we'll take a look at it, or, better yet, feel free to implement the changes
yourself and submit a pull request! If the issue is urgent, contact us at product@aspc.pomona.edu.
