#!/usr/bin/env bash

# https://stackoverflow.com/a/246128/2384183
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Loop through every file in source directory and sub directories except .git
# subdirectory and this script
IFS=$'\n' 
for f in $(find "$dir" \( -path "$dir/.git" -o -path "$dir/setup.sh" \) -prune -o -type f -print); do
	relative_path=$(realpath --relative-to="$dir" "$f")
	container=$(dirname "$relative_path")
	mkdir -p "$HOME/$container"
	cp -ibS '.bak' "$f" "$HOME/$relative_path"

	if [ "$container" = ".gnupg" ]; then
		chmod 700 "$HOME/$container"
		chmod 600 "$HOME/$relative_path"
	fi

	if [ "$container" = ".local/bin" ]; then
		chmod +x "$HOME/$relative_path"
	fi
done
