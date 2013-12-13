#!/bin/bash

## Remove tags we don't need

## cvs/ensembl-47-mp-1 is a duplicate of cvs/ensembl-47-mergepoint-1, which has not been recognized by the previous pattern
git tag -d cvs/attic/ensembl-47-mp-1 && git tag cvs/mergepoint/ensembl/47-1 cvs/attic/ensembl-47-mergepoint-1 && git tag -d cvs/attic/ensembl-47-mergepoint-1

# cvs/compara-hive-dev is the branchpoint of the branch cvs/compara-hive-dev2
git tag -d cvs/attic/compara-hive-dev
git tag cvs/attic/compara-hive-dev cvs/attic/compara-hive-dev2 && git tag -d cvs/attic/compara-hive-dev2

# cvs/bp-branch-new-seqstore is a duplicate / the branchpoint of cvs/branch-new-seqstore
git tag -d cvs/attic/bp-branch-new-seqstore



replace_manufactured_commit_with_cherrypick () {
	child_of_manufactured_commit=$1
	cherrypicked_commit=$2

	git checkout ${child_of_manufactured_commit}^^
	git cherry-pick -x $cherrypicked_commit
	new_commit=`git rev-parse HEAD`

	filter_branch_and_compare $child_of_manufactured_commit $new_commit
}

filter_branch_and_compare () {
	lca_commit=`git merge-base $1 $2`
	filter_ref_and_compare $1 $2 $lca_commit "branch" "heads"
	filter_ref_and_compare $1 $2 $lca_commit "tag" "tags"
}

filter_ref_and_compare () {
	child_commit=$1
	parent_commit=$2
	start_each_ref=$3
	git_cmd_name=$4
	git_internal_name=$5


	for c in `git $git_cmd_name --contains $child_commit`
	do
		echo "$child_commit $parent_commit" > .git/info/grafts
		git filter-branch -d /run/shm/ -f ${start_each_ref}..${c}
		rm .git/info/grafts

		if [[ `git diff $c refs/original/refs/$git_internal_name/$c | grep '' > /dev/null` ]]
		then
			echo "DIFF $c"
			return 1
		fi
		git update-ref -d refs/original/refs/$git_internal_name/$c
	done

}

# docs/healthchecks.txt removed just before ensembl-66-branchpoint
#commit_deletion=`git log --grep="this is a part of RelCo doc" --pretty=oneline | awk '{print $1}'`
#commit_firstbranch=`git log --grep="Fixed bug which still used genomic_align_group table" release/66  --pretty=oneline | awk '{print $1}'`
#filter_branch_and_compare $commit_firstbranch $commit_deletion


# sql/ensembl_compara_27_1.patch.sql cherry-picked from HEAD
#commit_mlsspatch=`git log --grep="patch for MLSS table in compara release 27" --pretty=oneline | awk '{print $1}'`
#commit_emptypatch=`git rev-parse release/27`
#replace_manufactured_commit_with_cherrypick $commit_emptypatch $commit_mlsspatch


# scripts/synteny/LoadComparaDb.pl cherry-picked from HEAD
#next_good_commit=`git log --grep="updates mainly" cvs/release/12 --pretty=oneline | awk '{print $1}'`
#source_commit=`git log --grep="^Added script to load the synteny data" --pretty=oneline | awk '{print $1}'`
#replace_manufactured_commit_with_cherrypick $next_good_commit $source_commit



# ensembl-4-branchpoint and branch-ensembl-4 duplicate a manufactured commit. Let's use only a single one instead
#commit_branchpoint4=`git log --grep="Added method fetch_align_name_by_align_id" release/4 --pretty=oneline | awk '{print $1}'`
#commit_inbranch4=`git log --grep="hacky little" cvs/attic/branch-baseline --pretty=oneline | awk '{print $1}'`
#filter_branch_and_compare $commit_inbranch4 $commit_branchpoint4

# remove sql/patch_36.sql ??? The patch is missing some queries, whilst patch_35_36.sql is correct, and present on both branches

#git checkout cvs/main


