#!/bin/sh -l

git config --global --add safe.directory /github/workspace

/lib/tech-writer-notify.sh -g . -s $SENDER_EMAIL -r $RECIPIENT_EMAIL -p $PROJECT
/lib/update-tag.sh
