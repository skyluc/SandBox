bash completion script for g8
================

This is an attempt to create a bash completion script for [g8](https://github.com/n8han/giter8).

Installation
---------

In Ubuntu, copy the ``g8.sh`` file to ``/etc/bash_completion.d/`` and restart your terminal.

Current status
-----------

* Uses ``g8 --list`` to complete the template name.
* ``g8 --list`` is slow, so the completion is slow.
* Does not support any options.

**Possible improvements:**

* Cache the list of available templates for a fastest completion
  * Display a 'in progress' message during the first fetch
* support the '-x' and '--xxx' options
* fetch the branches for the -b option

Documentation
--------

* [An introduction to bash completion](http://www.debian-administration.org/articles/317)
