#!/bin/bash
set -e
###############################################################
# Script Parameters                                           #
###############################################################

while getopts e: option
do
    case "${option}"
    in
    e) ENVIRONMENT=${OPTARG};;
    esac
done

if [ -z "$ENVIRONMENT" ]; then
    echo "-e is a required argument - Environment (dev, prod)"
    exit 1
fi

###############################################################
# Script Begins                                               #
###############################################################

terraform apply -auto-approve $ENVIRONMENT.plan

