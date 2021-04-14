
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
    _LINK="<a href='https://github.com/ePages-de/${_REPOSITORY}/commit/${_COMMIT_ID}'>${_COMMIT_ID}</a>"
    echo "  <li>${_LINK}: ${_COMMIT_MESSAGE}</li>"
  done
  echo "</ul>"
}

function render_email_body() {
  _REPOSITORY=$1
  _COMMIT_LINKS=$2
  _CHANGED_FILES=$3

  EMAIL_BODY=$(cat ${SCRIPT_DIR}/email-body.html)
  EMAIL_BODY=$(echo "${EMAIL_BODY}" | perl -p  -e "s@#CHANGED_REPO#@${_REPOSITORY}@g")
  EMAIL_BODY=$(echo "${EMAIL_BODY}" | perl -p  -e "s@#COMMIT_LINKS#@${_COMMIT_LINKS}@")
  EMAIL_BODY=$(echo "${EMAIL_BODY}" | perl -p  -e "s@#CHANGED_FILES#@${_CHANGED_FILES}@")

  echo "${EMAIL_BODY}"
}
