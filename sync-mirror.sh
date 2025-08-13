#!/bin/bash 

function do_sync(){

    target="$1"
    branch="$2"
    src="$3"
    dst="$4"

    rm -rf "$target" 
    git clone "$src"
    pushd "$target"
    git remote add downstream "$dst"
    git fetch --all
    git switch -c mirror "downstream/$branch"
    git merge "$branch"
    git push downstream "HEAD:$branch" 
    rm -rf "$target"
    popd
}


cat stream_main.txt | while read line
do
    for target in "${line[@]}"
    do
    
        arr_target=(${target})
        folder=${arr_target[0]}
	branch=${arr_target[1]}
        src=${arr_target[2]}
        dst=${arr_target[3]}

        echo "--------------------------"
        echo "TARGET: $folder"
	echo "BRANCH: $branch"
        echo "SRC   : $src"
        echo "DST   : $dst"
        echo "--------------------------"

        do_sync $folder $branch $src $dst

    done
done
