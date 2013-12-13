#!/bin/bash


## We can remove the cvs/main and cvs/start
git branch -d cvs/main
git tag -d cvs/start


## First thing is to clean-up the tags before we create new ones

## Remove all the branchpoints
for tag_bp in `git tag --list "cvs/*branchpoint*"`
do
  git tag -d $tag_bp
done


## In Compara, some recent ensemblgenomes branches are also tagged
## e.g. a commit has both cvs/tag-ensemblgenomes-16-69 and cvs/branch-ensemblgenomes-16-69
## We only need 1 ref there, so we delete the tag
for tag_eg in `git tag --list "cvs/tag-ensemblgenomes-*"`
do
  branch_eg=`echo $tag_eg | sed 's/tag/branch/'`
  commit_tag=`git rev-parse $tag_eg`
  commit_branch=`git rev-parse $branch_eg`
  if [[ $commit_tag == $commit_branch ]]
  then
    git tag -d $tag_eg
  fi
done

## Rename cvs/mergepoint-vega-XX to cvs/mergepoint/vega/XX
for tag_mp in `git tag --list "cvs/mergepoint-vega-*"`
do
  release=`echo $tag_mp | cut -d- -f3-`
  new_name="cvs/mergepoint/vega/$release"
  git tag $new_name $tag_mp && git tag -d $tag_mp
done

## Rename cvs/mergepoint-branch-ensembl-XX to cvs/mergepoint/ensembl/XX
for tag_mp in `git tag --list "cvs/mergepoint-branch-ensembl-*"`
do
  release=`echo $tag_mp | cut -d- -f4-`
  new_name="cvs/mergepoint/ensembl/$release"
  git tag $new_name $tag_mp && git tag -d $tag_mp
done


## Move all the tags under cvs/attic
for tag in `git tag | grep -v "^cvs/.*/"`
do
  new_name=`echo $tag | sed 's/\//\/attic\//'`
  git tag $new_name $tag && git tag -d $tag
done


## Branches like cvs/branch-ensembl-XX are renamed to release/XX and a cvs/release/ensembl/XX tag is created
## Will complain about the missing branches and the missing branchpoints
## In the case of Compara, there is no release 1, 2, and 3
for i in `seq 1 74`
do
  git branch -m cvs/branch-ensembl-$i release/$i && git tag cvs/release/ensembl/$i release/$i
done

## Branches like cvs/branch-vega-XX-dev are renamed to cvs/release/vega/dev/XX tags
for branch in `git branch --list "cvs/branch-vega-*-dev"`
do
  release=`echo $branch | cut -d- -f3- | sed 's/-dev//'`
  new_tag="cvs/release/vega/dev/$release"
  git tag $new_tag $branch && git branch -D $branch
done


## Branches like cvs/branch-vega-XX are renamed to cvs/release/vega/XX tags
for branch in `git branch --list "cvs/branch-vega-*"`
do
  release=`echo $branch | cut -d- -f3-`
  new_tag="cvs/release/vega/$release"
  git tag $new_tag $branch && git branch -D $branch
done


## Branches like cvs/branch-ensemblgenomes-XX-YY are renamed to cvs/release/ensemblgenomes/XX-YY tags
for branch in `git branch --list "cvs/branch-ensemblgenomes-*-*"`
do
  release=`echo $branch | cut -d- -f3-`
  new_tag="cvs/release/ensemblgenomes/$release"
  git tag $new_tag $branch && git branch -D $branch
done



## Move all the CVS branches to tags under cvs/attic
for branch in `git branch --list "cvs/*"`
do
  new_name=`echo $branch | sed 's/\//\/attic\//'`
  git tag $new_name $branch && git branch -D $branch
done

