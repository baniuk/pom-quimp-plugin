#!/bin/bash
# Update versions in pom and follow git flow
# Usage:
#		pushToNewVersion currentVer nextVer nextDev
# current Ver is version listed in pom currently (on two positions)
# nextVer is next full version
# nextDev is next development version

if [ "$#" -ne 3 ]; then
    echo "syntax: pushToNewVersion.sh currentVer nextVer nextDev"
    echo "	Assuming that one is on develop branch:"
    echo "	pushToNewVersion.sh 16.10.02-SNAPSHOT 16.10.03 16.10.04-SNAPSHOT"
    exit 1
fi

current=16.08.01-SNAPSHOT
next=16.10.01
nextdev=16.10.02-SNAPSHOT

git checkout develop
git checkout -b release/v$next
# change in two locations
sed -i "/$current/s/$current/$next/" pom.xml
git commit -am "Updated pom version to $next"
git checkout master
git merge release/v$next
git tag -a v$next -m "Release v$next"
git checkout develop
git merge release/v$next

sed -i "/$next/s/$next/$nextdev/" pom.xml
git commit -am "Push to next dev version"
git push --all