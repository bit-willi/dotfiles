# Dotfiles

## Requirements

1. Ansible

My OSX dotfiles can be found in the ```osx``` branch.

How to run:

1. ```$ git submodule update --init --recursive```
2. ```$ cd playbooks```
2. ```$ ansible-playbook -i inventory linux.yml -K```
