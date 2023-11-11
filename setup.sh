#!/usr/bin/env sh

set -euf

# https://stackoverflow.com/a/29835459/16330198
dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"

PREFIX="${PREFIX:-$HOME}"

# Loop through every file in source directory and sub directories except .git
# subdirectory and this script
files="$(find "$dir" \( -path "$dir/.git" -o -name '.*.swp' -o -path "$dir/setup.sh" \) -prune -o -type f -print | sort)"
until [ -z "$files" ]; do
	f="$(echo "$files" | head -1)"
	files="$(echo "$files" | tail -n +2)"

	relative_path="$(realpath --relative-to="$dir" "$f")"
	container="$(dirname "$relative_path")"
	dest="$PREFIX/$relative_path"
	dest_container="$PREFIX/$container"

	mkdir -p "$dest_container"

	if diff -q "$f" "$dest" > /dev/null 2>&1; then
		echo "Skipping identical $relative_path"
		continue
	fi

	if [ -s "$dest" ]; then
		resp=
		until [ "$resp" = 'y' ] || [ "$resp" = 'n' ]; do
			printf "Replace ~/%s? (y/n/d/q) " "$relative_path"
			read -r resp
			resp="$(printf '%.1s' "$resp" | tr '[:upper:]' '[:lower:]')"
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
