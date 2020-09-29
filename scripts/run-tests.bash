#!/usr/bin/env bash


# if any command inside script returns error, exit and return that error
set -e

if ! command -v ansible-lint &> /dev/null
then
	echo -e "ansible-lint could not be found"
    echo -e "Consider installing ansible lint with: pip install --user ansible-lint"
	exit
else command -v ansible-lint &> /dev/null

	# magic line to ensure that we're always inside the root of our application,
	# no matter from which directory we'll run script
	# thanks to it we can just enter `./scripts/run-tests.bash`
	cd "${0%/*}/.."
	
	echo "Running ansible lint on *.yml on git root"
	echo "............................"
	ansible-lint *.yml --force-color -p -x 204,701,301,305,401,303


fi
