#!/bin/bash

GIDIR=$(
  cd $( dirname $0 )
  echo $PWD
)
export PATH=$GIDIR:$PATH

# Import functions
source $GIDIR/cvs2git-hackery

REPO=$1

is_expected_cvsrepo $REPO 'eg-plugins/bacteria/conf/SiteDefs.pm,v'

cd $REPO

sed -i -e 's/UseNewInfoFmtStrings/#UseNewInfoFmtStrings/' CVSROOT/config
