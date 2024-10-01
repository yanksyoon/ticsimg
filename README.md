# ticsimg
TICS image builder with pre-installed artifactory:
* The docker image package pool is austere, e.g. 'go' is not installed (some projects take it from snap others don't), so the user can adapt it afterwards
* It installs TICS artifacts and code-checkers (including Coverity)
* The user has to provide the secrets for PKGTOKEN (to access Canonical's GHCR) and TICSAUTHTOKEN (to access Canonical's dashboard at TIOBE)
* Everything is installed under a 'runner' user as expected by the GH workflow action
