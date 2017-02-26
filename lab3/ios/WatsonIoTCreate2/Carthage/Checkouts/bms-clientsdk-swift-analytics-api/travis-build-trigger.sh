#!/bin/bash

##
# Copyright IBM Corporation 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##

## References for triggering builds using Travis CI API
# https://docs.travis-ci.com/user/triggering-builds

# If any commands fail, we want the shell script to exit immediately.
set -e

# Verify input params
if [ "$#" -ne 3 ]; then
  echo "Usage: travis-build-trigger [repo ID] [branch] [travis token]"
  exit 1
fi

# Set variables
repoId=$1
branch=$2
token=$3

# Payload for HTTP POST request
body='{
  "request": {
    "branch":"'$branch'"
  }
}'

curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Travis-API-Version: 3" \
  -H "Authorization: token $token" \
  -d "$body" \
  https://api.travis-ci.org/repo/$repoId/requests
