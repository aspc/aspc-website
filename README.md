# ASPC 2.0
This repo is intended to be a complete rewrite of aspc.pomona.edu (soon to be pomonastudents.org). The aim of this project is to: 
 - Put the content that most people use front and center
 - Redesign the website from the ground up
 - Streamline and trim legacy features

## Development
This repo is run and maintained by the ASPC Software Development Group, but anyone may contribute to this repository! If you attend Pomona College or any of the other Claremont Colleges and would like to join, please feel free to reach out to us at software@aspc.pomona.edu.

### Getting Up And Running
 1. Clone this repo
 2. Install [Vagrant](https://www.vagrantup.com/downloads.html) and [VMWare](https://www.virtualbox.org/wiki/Downloads)
 3. Run `vagrant up` from inside the cloned directory. Follow the prompts, default options are fine. This will handle dependency installation and all that jazz. 
 4. Run `vagrant ssh`, `cd /vagrant`, and then `rails server`.
 5. Navigate to [localhost:3000](http://localhost:3000) and see a local copy of this website up and running! 

 _If you will be using RubyMine, you can skip steps 4 and 5._

 _Note: Vagrant may seem magical/opaque and hard to understand, but for the purposes of facilitating development we've provded a quick summary over [containerization with Vagrant and VMWare]() should you be interested in learning more._

### IDE Option
As our application uses Ruby on Rails as its development framework, most of our developers use RubyMine for development. A free student download of the software can downloaded [here](https://www.jetbrains.com/shop/eform/students).

After following the "Getting Up and Running" section, you will need to configure RubyMine to use Vagrant and Ruby. 

1. Navigate to preferences
2. Navigate to Languages and Frameworks
3. Navigate to Ruby SDK and Gems
4. Use the + button in the upper left corner to add a "New remote..."
5. Choose the Vagrant option and in the "Ruby or version manager path" click the folder icon
6. Select home/vagrant/.rvm/bin/rvm in the pop-up menu
7. Press OK until saved 
8. You should now be able to click the play button in the upper-righthand corner to launch the server

_Note: You need to enable Vagrant within the IDE only the first time that you use the editor._

If you have a different favorite IDE that is compatible with the Rails framework, feel free to use it.


