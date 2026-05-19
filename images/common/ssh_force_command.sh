#!/usr/bin/env bash

if [ -z "$SSH_ORIGINAL_COMMAND" ]; then
	exec screen -DRR
fi

exec /bin/bash -c "$SSH_ORIGINAL_COMMAND"
