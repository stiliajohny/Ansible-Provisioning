#!/usr/bin/env bash
#title          : run-tests.sh
#description    :  Install and run ansible-lint 
#author         : John Stilia
#date           : 20200930
#version        : 0.1a
#usage          :./run-tests.sh
#notes          :
#bash_version   :3.2.57(1)-release
#============================================================================

# ---------------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------------
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'


# if any command inside script returns error, exit and return that error
set -e

if ! command -v ansible-lint &> /dev/null
then
	echo -e "${RED}ansible-lint could not be found${NOCOLOR}"
	echo -e "${RED}ansible-lint will be installed with python3 pip in 5 seconds. ${NOCOLOR}"
	echo -e "\n${YELLOW}Press Ctrl+C to stop the instalation of the package${NOCOLOR}"
	sleep 5
    if command -v pip3 &> /dev/null
    then
        export PYTHONUSERBASE=~/.local
        export PATH=$PATH:~/.local/bin
        pip3 install --user ansible-lint
    elif ! command -v pip3 &> /dev/null
    then
        echo -e "${RED}Cannot find pip3 install ansible-lint manually$NOCLOLOR}"
        exit
    fi
fi
if ! command -v yamllint &> /dev/null
then
	echo -e "${RED}yamllint could not be found${NOCOLOR}"
	echo -e "${RED}yamllint will be installed with python3 pip in 5 seconds. ${NOCOLOR}"
	echo -e "\n${YELLOW}Press Ctrl+C to stop the instalation of the package${NOCOLOR}"
	sleep 5
    if command -v pip3 &> /dev/null
    then
        export PYTHONUSERBASE=~/.local
        export PATH=$PATH:~/.local/bin
        pip3 install --user yamllint
    elif ! command -v pip3 &> /dev/null
    then
        echo -e "${RED}Cannot find pip3 install yamllint manually$NOCLOLOR}"
        exit
    fi
fi


# magic line to ensure that we're always inside the root of our application,
# no matter from which directory we'll run script
# thanks to it we can just enter `./scripts/run-tests.bash`
cd "${0%/*}/.."
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' \#

echo "Running ansible lint on *.yml on git root"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' .
ls *.yml |xargs -P10 -I{} ansible-lint {} --force-color -p -x 204,701,301,305,401,303
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' .
find ./ -type f -name "*.yml" | xargs -P10 -I{} yamllint {} -c ./scripts/yamllint.yml
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' \#
