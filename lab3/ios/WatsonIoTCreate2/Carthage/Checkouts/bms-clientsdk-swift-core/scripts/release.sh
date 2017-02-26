#!/bin/bash

# This script is used by Travis-CI to automatically release new versions of BMSCore.
# First, we check if the version specified in the .podspec does not already exist as a git tag.
# If the version does not exist yet, we add a git tag for this new version and publish to Cocoapods.

set -ev
cd ~/Documents
# GITHUB_TOKEN required for Travis to have permissions to push to the BMSCore repository
git clone https://ibm-bluemix-mobile-services:${GITHUB_TOKEN}@github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-core.git
cd bms-clientsdk-swift-core
git remote rm origin
git remote add origin https://ibm-bluemix-mobile-services:${GITHUB_TOKEN}@github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-core.git
version=$(grep -o 'version.*=.*[0-9]' BMSCore.podspec | cut -f 2 -d "'")
git fetch --tags
if [[ ! "$(git tag)" =~ "${version}" ]]; then
	echo "Publishing new version ${version} ";
	git tag $version;
	git push origin --tags;
	pod trunk push --allow-warnings;
fi