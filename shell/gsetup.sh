if [ -d .git ]; then
    branch_name=$(git symbolic-ref -q HEAD)
    branch_name=${branch_name##refs/heads/}
    branch_name=${branch_name:-HEAD}
    git push --set-upstream origin ${branch_name}
else
    echo 'Not a git repository'
fi;