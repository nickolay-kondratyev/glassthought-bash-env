# checks whether there is anything to commit.
git_isClean() {
  [[ -z $(git status -s) ]] && return 0 || return 1
}
export -f git_isClean

git.is_clean.announce() {
  if git_isClean; then
    echo "$PWD is Clean."
    return 0
  else
    echo "$PWD is NOT clean. (commit your changes)"
    return 1
  fi
}
export -f git.is_clean.announce

git_clean_removeUntrackedFiles() {
  git clean -fd -x
}
export -f git_clean_removeUntrackedFiles

git.submodule.init_and_update() {
  git submodule update --init --recursive || return 1
}
export -f git.submodule.init_and_update

git_log_noColor() {
  git log --graph --abbrev-commit --decorate --date=relative --format=format:'%h - (%ar) %s - %an %d' --all
}
export -f git_log_noColor

git_log_pretty() {
  git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all --color
}
export -f git_log_pretty
