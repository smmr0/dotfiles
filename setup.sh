#!/usr/bin/env bash

set -euf -o pipefail

# https://stackoverflow.com/a/246128/2384183
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PREFIX="${PREFIX:-$HOME}"

# Loop through every file in source directory and sub directories except .git
# subdirectory and this script
IFS=$'\n'
for f in $(find "$dir" \( -path "$dir/.git" -o -name '.*.swp' -o -path "$dir/setup.sh" \) -prune -o -type f -print | sort); do
	relative_path=$(realpath --relative-to="$dir" "$f")
	container=$(dirname "$relative_path")
	dest="$PREFIX/$relative_path"
	dest_container="$PREFIX/$container"

	mkdir -p "$dest_container"

	if diff -q "$f" "$dest" &> /dev/null; then
		echo "Skipping identical $relative_path"
		continue
	fi

	if [ -s "$dest" ]; then
		resp=
		until [ "$resp" = 'y' -o "$resp" = 'n' ]; do
			echo -n "Do you want to replace ~/$relative_path? (y/n/d/q) "
			read resp
			resp=$(echo -n "${resp:0:1}" | tr '[:upper:]' '[:lower:]')
			if [ "$resp" = 'y' ]; then
				if command -v trash > /dev/null 2>&1; then
					trash "$dest"
				else
					mv "$dest" "$dest.bak"
				fi
			elif [ "$resp" = 'd' ]; then
				diff "$dest" "$f" || true
			elif [ "$resp" = 'q' ]; then
				exit 0
			else
				continue 2
			fi
		done
	fi
	echo "Copying $relative_path"
	cp "$f" "$dest"

	if [ "$container" = '.gnupg' ]; then
		chmod 700 "$dest_container"
		chmod 600 "$dest"
	fi

	if [ "$container" = '.local/bin' ]; then
		chmod 755 "$dest"
	fi
done

echo 'Done'
