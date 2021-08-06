#!/usr/bin/env bash

# User-modifiable: parameters.

GITHUB_UTIL_DIR=~/senzing.git/github-util
GIT_REPOSITORY_DIR=~/senzing-test.git
GIT_MESSAGE="Add add-triage-label.yaml"
SOURCE_FILE=~/senzing.git/github-util/examples/update-git-action-file/add-triage-label.yaml

# User-modifiable: OS environment variable for use by github-util.py.

export SENZING_TOPICS_INCLUDED=test-ground

# Verify parameters.

if [ -z ${GITHUB_ACCESS_TOKEN+x} ]; then
    echo "GITHUB_ACCESS_TOKEN is not set.";
    exit
fi

# Make the directory to clone repositories into.

mkdir -p ${GIT_REPOSITORY_DIR}

# Process each submodule.

export REPOSITORIES=$(${GITHUB_UTIL_DIR}/github-util.py print-repository-names)
for REPOSITORY in ${REPOSITORIES[@]};
do
    echo "---- ${REPOSITORY} ------------------------------------------"

    DESTINATION_DIR=${GIT_REPOSITORY_DIR}/${REPOSITORY}/.github/workflows

    # Clone repository.

    cd ${GIT_REPOSITORY_DIR}
    git clone "git@github.com:Senzing/${REPOSITORY}.git"

    # Make repository directory the current working directory.

    cd ${GIT_REPOSITORY_DIR}/${REPOSITORY}

    # Checkout current main/master branch.

    git checkout main
    git checkout master
    git pull

    # Manipulate the files in the repository.

    mkdir -p ${DESTINATION_DIR}
    cp ${SOURCE_FILE} ${DESTINATION_DIR}

    # Add and commit all changes to local git repository.

    git add --all
    git commit -a -m "${GIT_MESSAGE}"

    # Push changes to GitHub

    git push

done
