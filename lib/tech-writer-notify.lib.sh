
function find_last_notified_commit() {
  git tag | grep --silent tech-writer-notified
  if [[ $? -eq 0 ]]; then
    echo "tech-writer-notified"
  else
    git rev-parse --short HEAD~1
  fi
}

function list_with_commit_links() {
  _REPOSITORY=$1
  _COMMIT_IDS=$2

  echo "<ul>"
  for _COMMIT_ID in ${_COMMIT_IDS}; do
    _COMMIT_MESSAGE=$(git show -s --format=%s ${_COMMIT_ID})
    _LINK="<a href='https://github.com/${_REPOSITORY}/commit/${_COMMIT_ID}'>${_COMMIT_ID}</a>"
    echo "  <li>${_LINK}: ${_COMMIT_MESSAGE}</li>"
  done
  echo "</ul>"
}

function render_email_body() {
  _PROJECT=$1
  _REPO_NAME=$2
  _COMMIT_LINKS=$3
  _CHANGED_FILES=$4

  EMAIL_BODY=$(cat ${SCRIPT_DIR}/email-body.html)
  EMAIL_BODY=$(echo "${EMAIL_BODY}" | perl -p  -e "s@#PROJECT#@${_PROJECT}@g")
  EMAIL_BODY=$(echo "${EMAIL_BODY}" | perl -p  -e "s@#REPO_NAME#@${_REPO_NAME}@g")
  EMAIL_BODY=$(echo "${EMAIL_BODY}" | perl -p  -e "s@#COMMIT_LINKS#@${_COMMIT_LINKS}@")
  EMAIL_BODY=$(echo "${EMAIL_BODY}" | perl -p  -e "s@#CHANGED_FILES#@${_CHANGED_FILES}@")

  echo "${EMAIL_BODY}"
}
