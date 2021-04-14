#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/tech-writer-notify.lib.sh

usage () {
     cat << EOF
DESCRIPTION:
The purpose of this script is notify the Tech Writers about changes in the
Beyond API documentation, so they can review it.

SYNOPSIS:
export MAILGUN_API_TOKEN=*******
export MAILGUN_MAILBOX=*******

$0 -s sender_email -r receipient_email -g git_repository

OPTIONS:
    -s   Sender email address
    -r   Recepient email address
    -g   Path to the Git repository to be evaluated.
    -h   Show this message.
    -?   Show this message.
EOF
}

while getopts "s: r: g: h ?" option ; do
     case $option in
          s)   SENDER_EMAIL="${OPTARG}"
               ;;
          r)   RECIPIENT_EMAIL="${OPTARG}"
               ;;
          g)   GIT_REPOSITORY="${OPTARG}"
               ;;
          h )  usage
               exit 0;;
          ? )  usage
               exit 0;;
     esac
done

if [[ -z "$SENDER_EMAIL" ]]; then
  echo "Missing mandatory parameter '-s'."
  exit 1
fi

if [[ -z "$RECIPIENT_EMAIL" ]]; then
  echo "Missing mandatory parameter '-r'."
  exit 1
fi

if [[ -z "$GIT_REPOSITORY" ]]; then
  echo "Missing mandatory parameter '-g'."
  exit 1
fi

if [[ -z "$MAILGUN_API_TOKEN" ]]; then
  echo "Missing environment variable 'MAILGUN_API_TOKEN'."
  exit 1
fi

if [[ -z "$MAILGUN_MAILBOX" ]]; then
  echo "Missing environment variable 'MAILGUN_MAILBOX'."
  exit 1
fi


cd ${GIT_REPOSITORY}

pwd

if [[ ! -d ".git" ]]; then
  echo "'${GIT_REPOSITORY}' is not a git repository."
  exit 1
fi

if [[ ! -f ".tech-writer-notify" ]]; then
  echo "No notifications for Tech Writers required in this repository."
  exit 0
fi

TOTAL_NUMBER_OF_COMMITS=$(git rev-list --count HEAD)
if [[ ${TOTAL_NUMBER_OF_COMMITS} -le 1 ]]; then
  echo "Cannot search for changes interesting for Tech Writers in inital commit of the repository."
  exit 0
fi

REPO_NAME=${PWD##*/}
RELEVANT_PATHS=$(cat .tech-writer-notify)

COMMIT_LAST_NOTIFIED=$(find_last_notified_commit)
COMMIT_IDS=$(git log ${COMMIT_LAST_NOTIFIED}..HEAD --pretty=format:"%h" -- ${RELEVANT_PATHS})

if [[ -z "$COMMIT_IDS" ]]; then
  echo "There are no new changes which the Tech Writers need to be informed about."
  exit 0
fi

COMMIT_LINKS=$(list_with_commit_links ${REPO_NAME} "${COMMIT_IDS}")
CHANGED_FILES=$(git diff ${COMMIT_LAST_NOTIFIED}..HEAD --name-only -- ${RELEVANT_PATHS})
EMAIL_BODY=$(render_email_body ${REPO_NAME} "${COMMIT_LINKS}" "${CHANGED_FILES}" )

curl --fail --user "api:${MAILGUN_API_TOKEN}" \
  https://api.eu.mailgun.net/v3/${MAILGUN_MAILBOX}/messages \
  -F subject="[${REPO_NAME}] API Documentation changes" \
  -F from="${SENDER_EMAIL}" \
  --form-string html="$EMAIL_BODY" \
  -F to="${RECIPIENT_EMAIL}"

if [[ $? -ne 0 ]]; then
  echo "Failed to send email with Mailgun mailbox '${MAILGUN_MAILBOX}'."
  exit 1
fi

echo # Force newline after the cURL output
