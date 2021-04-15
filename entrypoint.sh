#!/bin/sh -l

pwd

find .

/lib/tech-writer-notify.sh -g . -s $SENDER_EMAIL -r $RECIPIENT_EMAIL  
