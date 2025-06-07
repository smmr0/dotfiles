#!/usr/bin/env sh

set -euf

relative_path() {
	f="$1"
	relative_to="$2"

	realpath --logical --relative-to="$relative_to" "$f" 2> /dev/null ||
		echo "${f#"$relative_to/"}" # TODO: Handle traversing up and then down (cousin directories)
}

source_root="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)" # https://stackoverflow.com/a/29835459/16330198
dest_root="${PREFIX:-$HOME}"

# Loop through every file in source directory and sub directories except .git
# subdirectory and this script
files="$(
	find "$source_root" \
		\( \
			-path "$source_root/.git" \
			-o \
			-name '.*.swp' \
			-o \
			-path "$source_root/setup.sh" \
		\) -prune \
		-o \
		-type f \
		-print \
		| sort
)"
until [ -z "$files" ]; do
	source_f="$(echo "$files" | head -1)"
	files="$(echo "$files" | tail -n +2)"

	f="$(relative_path "$source_f" "$source_root")"
	dir="$(dirname "$f")";
	if [ "$dir" = '.' ]; then dir=; fi
	dest_f="$dest_root/$f"
	dest_dir="$dest_root${dir:+"/$dir"}"

	if [ ! -d "$dest_dir" ]; then
		mkdir -p "$dest_dir"

		if [ "$dir" = '.gnupg' ]; then chmod 700 "$dest_dir"; fi
	fi

	if diff -q "$f" "$dest_f" > /dev/null 2>&1; then
		echo "Skipping identical $f"
		continue
	fi

	if [ -s "$dest_f" ]; then
		resp=
		until [ "$resp" = 'y' ] || [ "$resp" = 'n' ]; do
			printf "Replace ~/%s? (y/n/d/q) " "$f"
			read -r resp
			resp="$(printf '%.1s' "$resp" | tr '[:upper:]' '[:lower:]')"
			if [ "$resp" = 'y' ]; then
				if command -v trash > /dev/null 2>&1; then
					trash "$dest_f"
				else
					mv "$dest_f" "$dest_f.bak"
				fi
			elif [ "$resp" = 'd' ]; then
				diff "$dest_f" "$f" || true
			elif [ "$resp" = 'q' ]; then
				exit 0
			else
				continue 2
			fi
		done
	fi
	echo "Linking $f"
	(
		cd "$dest_dir"
		ln -s "$(relative_path "$source_f" .)" .
	)
done
