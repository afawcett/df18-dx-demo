export FORCE_SPINNER_DELAY=
export FORCE_SHOW_SPINNER=

created="$(sfdx force:org:create -s -f config/project-scratch-def.json --json)"
pushed="$(sfdx force:source:push --json)"
display="$(sfdx force:org:display --verbose --json)"
sfdxAuthUrl="$(echo ${display} | jq -r .result.sfdxAuthUrl)"

file="module.exports = {
  authUrl:
    \"${sfdxAuthUrl}\"
};"

echo "$file" > "authUrl.js"