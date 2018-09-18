export FORCE_SPINNER_DELAY=
export FORCE_SHOW_SPINNER=

BLUE=`tput setaf 4`
RESET=`tput sgr0`

invokeCmd() {
  echo "CMD: ${BLUE}$1${RESET}"
  eval $1
}

invokeCmd "sfdx force:org:create -s -f config/project-scratch-def.json --json"
invokeCmd "sfdx force:source:push --json"
invokeCmd "sfdx force:data:tree:import -f ./sampledata/Campaign-Event.json"
invokeCmd sfdxAuthUrl="$(sfdx force:org:display --verbose --json | jq -r .result.sfdxAuthUrl)"

file="module.exports = {
  authUrl:
    \"${sfdxAuthUrl}\"
};"

echo "$file" > "authUrl.js"