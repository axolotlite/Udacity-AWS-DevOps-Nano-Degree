#!/bin/bash

#script that creates stack or updates it.
if [[ $# -eq 0 ]]; then
    echo "No arguments supplied... exiting"
    exit 1
elif [[ $# -lt 2 ]]; then
    echo -e "Insufficient arguments supplied...\nstack-name and file.yml needed (parameters are optional)\n./$(basename $0) [stack-name] [file.yml] (parameters.json)"
    exit 1
elif [[ ! -f $2 ]]; then
    echo "File doesn't exist... exiting"
    exit 1
elif [[ $# -eq 2 ]] ; then
    aws cloudformation create-stack \
        --stack-name $1 \
        --template-body file://$2 \
        --region=us-west-2 \
        || \
    echo 'updating stack' ; \
    aws cloudformation update-stack \
        --stack-name $1 \
        --template-body file://$2 \
        --region=us-west-2 \
        || exit $?
elif [[ $# -eq 3 ]]; then
    aws cloudformation create-stack \
        --stack-name $1 \
        --template-body file://$2 \
        --parameters file://$3 \
        --region=us-west-2 \
        || \
    echo 'updating stack' ; \
    aws cloudformation update-stack \
        --stack-name $1 \
        --template-body file://$2 \
        --parameters file://$3 \
        --region=us-west-2 \
        || exit $?
fi

exit 0