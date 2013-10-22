#!/bin/bash

GIDIR=$(
  cd $( dirname $0 )
  echo $PWD
)
export PATH=$GIDIR:$PATH

# Import functions
source $GIDIR/cvs2git-hackery

REPO=$1

is_expected_cvsrepo $REPO 'ensembl/modules/Bio/EnsEMBL/AceDB/Attic/Contig.pm,v'

cd $REPO

# Restore some missing (outdated?) deltatext, else cvs2git refuses to run
fake_lost_deltatext \
    modules/Bio/EnsEMBL/AceDB/Contig.pm -J \
    1.6 1.5 1.4 1.3 1.2 1.1 \
    >> ensembl/modules/Bio/EnsEMBL/AceDB/Attic/Contig.pm,v

fake_lost_deltatext \
    ensembl/scripts/gtf_dump.pl -J \
    1.1.2.1 1.1.2.2 1.1.2.3 1.1.2.4 1.1.2.5 \
    >> ensembl/scripts/Attic/gtf_dump.pl,v

# Fix a non-ASCII commit comment; guess the original
perl -i -pe 's/(XrefParser::BaseParser)\xAD(>method)/$1-$2/' ensembl/misc-scripts/xref_mapping/XrefParser/FastaParser.pm,v
