#!/usr/bin/env bash

set -Eeuo pipefail

generate_readme() {
  echo "# rndm - A Random Number Generator (for a Bashly tutorial)"
  echo
  echo "Check the plan in [#1](https://github.com/meleu/rndm/issues/1)."
  echo
  echo "## Commit History"
  echo
  commit2md
}

# Print all commit messages as markdown, oldest first
commit2md() {
  local base_url="https://github.com/meleu/rndm/commit"
  local title hash body

  git log --reverse --pretty=format:'%s%x00%H%x00%b%x00' \
    | while IFS= read -r -d '' title \
      && IFS= read -r -d '' hash \
      && IFS= read -r -d '' body; do

      [[ "$title" == *README.md* || "$title" == *"First commit"* ]] && continue

      echo "### ${title//$'\n'/}"
      echo -e "\n[link to commit](${base_url}/${hash})\n"
      echo "$body"
    done
}

generate_readme
