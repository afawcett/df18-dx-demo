export FORCE_SPINNER_DELAY=
export FORCE_SHOW_SPINNER=

BLUE=`tput setaf 4`
RESET=`tput sgr0`

invokeCmd() {
  echo "CMD: ${BLUE}$1${RESET}"
  eval $1
}


#### setup

invokeCmd "yarn install"

CMT_FILE="force-app/main/default/customMetadata/UntappedAPIConnection.Default.md-meta.xml"
TARGET_KEY="yourclientid"
sed -i '' "s/$TARGET_KEY/$UNTAPPD_CLIENT_ID/g" $CMT_FILE

TARGET_KEY="yourclientsecret"
sed -i '' "s/$TARGET_KEY/$UNTAPPD_CLIENT_SECRET/g" $CMT_FILE

git update-index --assume-unchanged force-app/main/default/customMetadata/UntappedAPIConnection.Default.md-meta.xml

invokeCmd "sfdx force:config:set defaultdevhubusername=gs0"

#### deploy

invokeCmd "sfdx force:org:create -s -f config/project-scratch-def.json --json"
invokeCmd "sfdx force:source:push --json"
invokeCmd "sfdx force:user:permset:assign -n UntappedIntegration --json"
invokeCmd "sfdx force:data:tree:import -f ./sampledata/Campaign-Event.json --json"
invokeCmd sfdxAuthUrl="$(sfdx force:org:display --verbose --json | jq -r .result.sfdxAuthUrl)"

file="module.exports = {
  authUrl:
    \"${sfdxAuthUrl}\"
};"

echo "$file" > "authUrl.js"