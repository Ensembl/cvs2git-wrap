#!/bin/bash

GIDIR=$(
  cd $( dirname $0 )
  echo $PWD
)
export PATH=$GIDIR:$PATH

# Import functions
source $GIDIR/cvs2git-hackery

REPO=$1

is_expected_cvsrepo $REPO 'biomart-perl/lib/BioMart/QueryRunner.pm,v'

cd $REPO

sed -i -e 's/PamAuth=no/#PamAuth=no/' CVSROOT/config
