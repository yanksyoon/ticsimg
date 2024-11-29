# ticsimg
dockerfile: TICS docker image builder with pre-installed artifactory:
* The docker image package pool is austere , so the user can adapt it afterwards
* It installs TICS artifacts and code-checkers (including Coverity)
* The user has to provide the secrets for PKGTOKEN (to access Canonical's GHCR) and TICSAUTHTOKEN (to access Canonical's dashboard at TIOBE)
* Everything is installed under a 'runner' user as expected by the GH workflow action
tics_installer: script to install tics on a self-hosted runner
test/: dummy/validation 'hello world' project
