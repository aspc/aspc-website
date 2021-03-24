# Getting Started

Once you've successfully followed the steps outlined in the [README](../README.md), you're good to go! 
However, if you'd like to also set up this project to work with an IDE or have some other questions, this is 
a good place to start.

## Core Technologies

As an open-source project, this application would not be possible without the labor of countless others. We try
to maintain an up-to-date list of [core technologies](technologies.md) we use and build upon. Check it out! 

## What is Vagrant?
Per the official tool's [website](https://www.vagrantup.com/intro/index.html):

> Vagrant lowers development environment setup time, increases production parity, and makes the "works on my machine" excuse a relic of the past

At first Vagrant may seem magical and hard to understand, so you may find it worthwhile to read the [official quickstart guide](https://www.vagrantup.com/intro/getting-started/up.html).
We promise it's worth it!

## Setting up the IDE -- RubyMine
As our application uses Ruby on Rails as its development framework, most of our developers use RubyMine for development. 
A free student download of the software can downloaded [here](https://www.jetbrains.com/shop/eform/students).

After following the "Getting Up and Running" section from the primary [README](../README.md), 
we will need to configure RubyMine to use Vagrant and Ruby. 

0. Download and open up RubyMine.
1. Open up `Preferences`
2. Navigate to `Languages and Frameworks`
3. Navigate to `Ruby SDK and Gems`
4. Use the `+` button in the upper left corner to add a "New remote..."
5. Choose the `Vagrant` option and in the "Ruby or version manager path" click the folder icon
6. Select `home/vagrant/.rvm/bin/rvm` in the pop-up menu
    - After clicking ok, ensure you've selected this remote in the sidebar!
7. Click ok and apply the settings.

You should now be able to click the play button in the upper-right corner to launch the server!