if [[ -z "${GIT_REPOS}" ]]; then
  # logInfo "GIT_REPOS is not set (You can set it prior to sourcing). Setting to default value of $HOME/git_repos"
  export GIT_REPOS="$HOME/git_repos"
  mkdir -p "$GIT_REPOS"
fi

export GT_SANDBOX_REPO="$GIT_REPOS/glassthought-sandbox"
export GT_SANDBOX="$GT_SANDBOX_REPO"
