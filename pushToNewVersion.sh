#!/bin/bash
# Update versions in pom and follow git flow. 
# This tool is for pushing plugin pom to new version when
# new QuimP is released.
# Usage:
#	pushToNewVersion currentVer nextVer nextDev
# 		nextVer is next full version
# 		nextDev is next development version

if [ "$#" -ne 3 ]; then
    echo "syntax: pushToNewVersion.sh nextVer nextDev"
    echo "	Assuming that one is on develop branch:"
    echo "	pushToNewVersion.sh 16.10.03 16.10.04-SNAPSHOT"
    exit 1
fi

current=$(mvn help:evaluate -Dexpression=project.version | sed '4q;d' | awk '{print $4}')
next=$1
nextdev=$2

echo "Current pom version is $current"
echo "You are going to push it to $next release and $nextdev development"
read -r -p "Are you sure to continue? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        ;;
    *)
        exit 1
        ;;
esac

git checkout develop
git checkout -b release/v$next
# change in two locations
sed -i "/$current/s/$current/$next/" pom.xml
git commit -am "Updated pom version to $next"
git checkout master
git merge release/v$next
mvn install
git tag -a v$next -m "Release v$next"
git checkout develop
git merge release/v$next

sed -i "/$next/s/$next/$nextdev/" pom.xml
git commit -am "Push to next dev version"
mvn install
git branch -d release/v$next
#git push --all trac
#git push --all origin