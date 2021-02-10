# Using rakudo-pkg for testing upstream Rakudo

This repo can be used to test the upstream MoarVM/NQP/Rakudo and zef releases.
In order to do this fork this repo, go to Actions and enable the `devbuild`
action.

![Enabled action](actions.png?raw=true "Actions")

You can run the `devbuild action` by clicking on `Run workflow` where you can
customise the build and give a version for MoarVM, NQP, Rakudo and zef (HEAD,
a tag or a commit) and the configure command for MOARVM, NQP and Rakudo. You
can also supply a command to e.g. make changes to the source files and add
environment variables to the build system. You can also change the branch if
needed (e.g. a work-in-progress test setup).

![devbuild workflow](devbuild.png?raw=true "devbuild workflow")

Tests are run in verbose mode. If the build process produces corefiles, 
you'll find them as artifact below the run workflow.

Don't forget to update your fork regularly, so new OS releases are added to the
actions and/or functionality added to the flow:

```
git remote add upstream https://github.com/nxadm/rakudo-pkg.git
git pull upstream master
```