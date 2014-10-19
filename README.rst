========================
Drexel Dissertation Template Files
========================

This repository (hereafter, 'repo') is a collection of all documents
and template files needed for the completion of a Ph.D. in physics at
Drexel University. Attempts will be made to keep this repo
comprehensive and up-to-date.

General Template
----------------

The latex dissertation template file, entitled, 'example.tex' contains
a nearly bare bones example of a dissertation. A PDF version of this
example can be obtained by running:

.. code-block:: bash

    $ pdflatex example.tex

The latex class file, 'drexel-thesis.cls', required for styling and
arrangement, has also been included here.

Dissertation Requirements
-------------------------

A pdf document entitled, 'thesishandbook.pdf' has also been included
and contains all requirements for formatting and arrangement of
a Drexel Dissertation, according to the Drexel University Office of
Research and Graduate Studies. The dissertation template,
'example.tex', should in principle always be up-to-date to reflect
these formatting and arrangement requirement at all times.

Purpose of this repository
--------------------------

All Drexel University graduate physics students are allowed and
encouraged to use this repos. The purpose of this reposit is for there
to be one central (public) location for students to come to in order
to aid them in writing and formatting their dissertation. A few rules
should be outlined to ensure that this be useful for everyone (now and
in the future):

  * All users are granted full privileges to this repo; no exceptions.
  * All users are very much encouraged (but of course are in no way required) to upload their own personal dissertations as examples for less senior students.
  * All users should generally refrain from deleting files, unless it has been determined (and ideally confirmed by a qualified person) that something is either out-of-date, or is incorrect. Another exception is the deletion of personal thesis files located in a sub-directory of this repo.

---------

Examples
--------

.. topic:: Getting Started

Git/Github has a bit of a steep learning curve. The first step is to
create a complete copy of the DrexelPhysics/DissertationDocs
repo to associate with your own Github account. If you do not already
have a Github account, now would be a good time to create one. 
Creating a new (and personal) remote copy of this repo is called
'forking', and only needs to be done once.

To fork the DrexelPhysics/DissertationDocs repo, simply navigate to
the project repository on Github, and click on 'Fork', most likely
located in the upper right corner of the page. Make sure to select
your own account as the location.

After the repo has been forked, you now have two version of
DissertationDocs. The first is the public project (owner:
DrexelPhysics), and the other is your own personal copy
(UNAME/DissertationDocs; WARNING: this repo is likely still
public. Avoid putting any sensitive information here).  

It is now time to create a local copy of your own repo,
DissertationDocs. In the command line, navigate to some location 
on your local machine, and create a directory called, 'drexelphysics.'
Within this directory, create another directory called,
'dissertationdocs.' Now clone your remote repo into this repository:

.. code-block:: bash

    $ git clone https://github.com/UNAME/DissertationDocs.git

where 'UNAME' is your Github username. This also only needs to be done
once. You are now free to create or modify files within this new local
git directory.

The last thing one needs to do, is to tell git where 'upstream' is
located. Upstream should always point to the larger
DrexelPhysics/DissertationDocs repo. This ensures that updating your
personal remote and local repos will always pull from the correct
location. In order to set upstream, do the following within your local
git directory:

.. code-block:: bash

    $ git remote add upstream git@github.com:DrexelPhysics/DissertationDocs.git

If this has worked, a simple:

.. code-block:: bash

    $ git remote -v

will show the following: 

.. code-block:: bash

    $ origin	https://github.com/UNAME/DissertationDocs.git (fetch)
    $ origin	https://github.com/UNAME/DissertationDocs.git (push)
    $ upstream	git@github.com:DrexelPhysics/DissertationDocs.git (fetch)
    $ upstream	git@github.com:DrexelPhysics/DissertationDocs.git (push)

The process of setting your upstream only needs to be done once.

.. topic:: Making changes to files, and updating your own local and remote repos

.. topic:: Pushing changes upstream
