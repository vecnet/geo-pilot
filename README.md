# GeoBlacklight for VecNet Digital Library

Work-in-progress :

Adding GeoBlacklight to an institutional repository with a Fedora DAM.

## About

[GeoBlacklight](https://github.com/geoblacklight/geoblacklight) is a collaboration between several institutions and adds GIS capability to the [Blacklight](https://github.com/projectblacklight/blacklight) discovery interface for [Solr](https://github.com/apache/solr).

This project  builds the required components for GeoBlacklight and the Vecnet Digital Library using [Ansible](http://www.ansible.com/home) to create a [Vagrant](https://www.vagrantup.com/) virtual machine for development.


##Getting Started

Requires `vagrant` and `git` to be installed

Clone the repo

* `git clone https://github.com/vecnet/geo-pilot.git`

Checkout the `ansible` branch
*  `cd geo-pilot`

*  `git checkout ansible`

Create the Vagrant VM (should take a while to download and install and output task status along the way)
*  `vagrant up`

Open the localhost port specified in the output to view the application

* e.g. `http://localhost:3001/`

Hack Ruby on Rails.
