#!/bin/bash -e

# Require github_token
#if [[ -z "${GITHUB_TOKEN}" ]]; then
#  # shellcheck disable=SC2016
#  MESSAGE='Missing env var "github_token: ${{ secrets.GITHUB_TOKEN }}".'
#  echo -e "[ERROR] ${MESSAGE}"
#  exit 1
#fi

get_current_branch() {
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
  if [[ "${branch}" == "HEAD" ]]; then
    branch=""
  fi
  printf '%s' "${branch}"
}

GIT_CURRENT_BRANCH=$(get_current_branch)

git filter-branch --msg-filter '
	cat &&
        echo "Acked-by: Bugs Bunny <bunny@bugzilla.org>"
' origin/${GIT_CURRENT_BRANCH%%/*}..HEAD

git push -f origin $GIT_CURRENT_BRANCH
