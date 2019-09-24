#!/bin/sh

# This script automatically deploys the current branch to github pages:
# - It generates a new build from the current branch
# - Commits it to the local gh-pages branch
# - Pushes both the master and gh-pages branches to the remote

if [ "`git status -suno`" ]
# -suno = --short --untracked-files=no
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

echo "Pushing to github"
git push --all