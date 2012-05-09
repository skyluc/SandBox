Extracting scalatest integration
================================

This folder contains scripts I created to be able to extract the `scalatest`_ suport for `Scala IDE`_ in its own repository.

`Chee Seng`_ did his work in a fork of Scala IDE, but at the end, we wanted to have this code it is own repository to be able to have decoupled release schedules.

I went through a few iterations before getting something I was satisfied with.

doIt.sh
-------

After googling a bit, looking at different explanations, `this one`__ mainly, and doing some experimentation, I decided to try to trim out everything I did want to keep. As I wanted to keep 2 folders, I could not use the technic explained in the Stack Overflow post.

It kind of work, but to have a clean repository, I would have had to also find and remove the files and folders that are not visible in HEAD anymore, but are in the history. Too much work.

__ http://stackoverflow.com/questions/359424/detach-subdirectory-into-separate-git-repository

doIt2.sh
--------

The idea of the second attempt was to mix the 'detach subdirectory' idea from the Stack Overflow post, with 'subtree' merging from `this post`__

This worked very well, but by doing this, I was losing the history of the changes made when the scalatest support was not in its own subprojects (and subfolders), but mixed in org.scala-ide.sdt.core.

__ http://nuclearsquid.com/writings/subtree-merging-and-you/

doIt3.sh
--------

To be able to keep the full history of the work done by Chee Seng, I decided to simply apply all commit done for the scalatest support in a clean repo. I used ``git log`` to create a list of the commit contained only in Chee Seng fork, and then applyed all of them using ``git cherry-pick``. I did not find a way to just force cherry-pick to apply the commit without complaining, so I added a bit of bash magic to fix the few conflics.

After pushing to github, cloning back and removing some no more needed folders, I have a pretty clean repository containing all the history.

.. _Chee Seng: https://github.com/cheeseng
.. _scalatest: http://scalatest.org
.. _Scala IDE: http://scala-ide.org
