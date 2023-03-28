cd.git-repos-workplace() {
  if [[ -z "${GIT_REPOS}" ]]; then
    echo "GIT_REPOS is not set. Exiting."
    return 1
  fi

  cd "$GIT_REPOS" || return 1
}

gt.init.glassthought-sandbox() {
  cd.git-repos-workplace || return 1

  print.green "Cloning glassthought-sandbox repo... "
  echo "(this may take a while)"

  git clone https://github.com/nickolay-kondratyev/glassthought-sandbox.git
}

cd.glassthought.sandbox() {
  if [[ ! -d "${GT_SANDBOX_REPO}" ]]; then
    echo "Directory ${GT_SANDBOX_REPO} does NOT exists. Will attempt to initialize glassthought repos."

    gt.init.glassthought-sandbox || return 1
  fi

  cd "$GIT_REPOS/glassthought-sandbox" || return 1
}
export -f cd.glassthought.sandbox

cd.gt.sandbox() {
  cd.glassthought.sandbox || return 1
}
export -f cd.gt.sandbox

cd.gt.sandbox.last-modified() {
  cd.glassthought.sandbox || return 1

  cd.last-changed-dir || return 1
}
export -f cd.gt.sandbox
