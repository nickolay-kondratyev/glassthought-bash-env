
gt.sandbox.checkout.commit.cleanly() {
  gt.sandbox.checkout.commit "$1" || return 1

  git_clean_removeUntrackedFiles || return 1
}

gt.sandbox.install-tools() {
  cmd.run.announce "brew install cmake" || return 1
}

gt.sandbox.init-full() {
  gt.sandbox.checkout.latest-main.cleanly || return 1

  gt.sandbox.install-tools || return 1
}

gt.sandbox.checkout.latest-main() {
  cd.glassthought.sandbox || return 1
  git.is_clean.announce || return 1

  cmd.run.announce "git checkout main" || return 1
  cmd.run.announce "git pull origin main" || return 1
}

gt.sandbox.checkout.latest-main.cleanly() {
  gt.sandbox.checkout.latest-main || return 1

  git_clean_removeUntrackedFiles || return 1
}

gt.sandbox.checkout.commit() {
  if [[ -z "${1}" ]]; then
    print.green "${FUNCNAME[0]}"
    echo ": given commit hash from glassthought-sandbox repo. Checks out the commit."
    echo ""
    echo "NO-OP. Example call:"
    echo.green "${FUNCNAME[0]} 1e9cd6a"
    return 1
  fi
  local commit_hash="$1"

  cd.glassthought.sandbox || return 1
  git.is_clean.announce || return 1

  git.submodule.init_and_update || return 1

  # Check if commit does not exist using rev parse
  if ! git rev-parse ${commit_hash}; then
    echo "Commit ${commit_hash:?} does not exist locally."

    # If we didnt find the commit we wanted we will try to pull
    # the latest changes and see if that resolves getting the commit has.
    cmd.run.announce "git fetch origin" || return 1

    if ! git rev-parse ${commit_hash}; then
      echo.yellow "Commit ${commit_hash:?} does not exist locally after pulling latest changes."
      return 1
    fi
  fi

  git checkout -b "sandbox-commit-${commit_hash}" \
  || git checkout "sandbox-commit-${commit_hash}" \
  || return 1

  git reset --hard "${commit_hash}" || return 1

  echo ""
}

pwd.verify.within.dir() {
  if [[ -z "${1}" ]]; then
    print.green "${FUNCNAME[0]}"
    echo ": given directory. Verifies that we are within that directory (somewhere underneath it)."
    echo ""
    echo "NO-OP. Example call:"
    echo.green "${FUNCNAME[0]} /some-dir"
    return 1
  fi

  # Simplified just to check for match of given path
  if pwd | grep -q "${1}"; then
    return 0
  else
    echo.red "Current directory is NOT within ${1}. PWD=$(pwd)"
    return 1
  fi
}

# GT_SANDBOX_PREFIXED_PWD is set if succesfull
# GT_SANDBOX_PREFIXED_PWD is NOT `cd $GT_SANDBOX_PREFIXED_PWD` friendly.
_gt.sandbox.set.GT_SANDBOX_PREFIXED_PWD() {
  pwd.verify.within.dir "${GT_SANDBOX_REPO}" || return 1

  # Set input path variable
  input_path="$PWD"

  sandbox_repo_var_string='${GT_SANDBOX_REPO}'
  sed_expression="s|${GT_SANDBOX_REPO:?}|${sandbox_repo_var_string:?}|"

  # Replace string in input path
  result=$(echo "${input_path}" | sed "${sed_expression:?}")

  # Remove trailing slash if present
  result=${result%/}

  echo "GT_SANDBOX_PREFIXED_PWD=${result}"
  export GT_SANDBOX_PREFIXED_PWD="${result}"
}


# Runs the given command at the current directory,
# if the command is successful, it will commit the changes.
# As well as record the output and a way to reproduce the command with
# the change.
gt.sandbox.snapshot.run() {
  local cmd="$*"

  local start_dir="$PWD"
  local commit_msg_file="/tmp/gt-sandbox-commit-msg.md"

  pwd.verify.within.dir "${GT_SANDBOX_REPO:?}" || return 1

#  # Check if commit history already has such command message within it
#  # If it does, ask user if they want to continue.
#  if git_log_pretty | grep -q "'${cmd}'"; then
#    echo ""
#
#    echo "Matching commits:"
#    git_log_pretty | grep "'${cmd}'"
#
#    echo ""
#    echo -n "Command '"
#    print.yellow "${cmd:?}"
#    echo "' already exists in commit history."
#    if cli.ask_yes_no "Do you want to continue?"; then
#      echo "Continuing..."
#    else
#      echo "Aborting."
#      return 1
#    fi
#  fi

  # Set this before running the command, in case we change directories or something
  # within the running command.
  _gt.sandbox.set.GT_SANDBOX_PREFIXED_PWD

  # Run the command to see if it is successful.
  # Output will be in $CMD_RUN_RECORDING_FILE
  cmd.run.announce.record "${cmd}" || return 1

  echo "Snapshot of command: '${cmd}' in ${GT_SANDBOX_PREFIXED_PWD:?}" > "${commit_msg_file}"
  echo "" >> "${commit_msg_file}"
  echo "" >> "${commit_msg_file}"
  echo "## Recorded output of command:" >> "${commit_msg_file}"
  echo '```' >> "${commit_msg_file}"
  cat "${CMD_RUN_RECORDING_FILE:?}" >> "${commit_msg_file}"
  echo '```' >> "${commit_msg_file}"
  echo "" >> "${commit_msg_file}"

  cat "${commit_msg_file}"

  # If we are here, the command was successful.
  # We will commit the changes.
  cd "${GT_SANDBOX_REPO:?}" || return 1
  git add . || return 1
  git commit --file=${commit_msg_file} || return 1
  echo.green "Successfully ran command and committed changes with first commit."

  # --------------------------------------------------------------------------------
  # Second commit
  local first_commit_hash="$(git rev-parse HEAD)"
  local first_commit_hash_short="$(git rev-parse --short HEAD)"

  mkdir -p "${GT_SANDBOX_REPO:?}/.gt-metadata/commit-messages"
  commit_msg_file="${GT_SANDBOX_REPO:?}/.gt-metadata/commit-messages/${first_commit_hash:?}.md" || return 1

  # Formulate message of second commit
  echo "## Command to reproduce:" >> "${commit_msg_file}"
  echo '```bash' >> "${commit_msg_file}"
  echo "gt.sandbox.checkout.commit ${first_commit_hash_short:?} \\" >> "${commit_msg_file}"
  echo "&& cd \"${GT_SANDBOX_PREFIXED_PWD:?}\" \\" >> "${commit_msg_file}"
  echo "&& cmd.run.announce \"${cmd}\"" >> "${commit_msg_file}"
  echo '```' >> "${commit_msg_file}"
  echo "" >> "${commit_msg_file}"
  echo "## Recorded output of command:" >> "${commit_msg_file}"
  echo '```' >> "${commit_msg_file}"
  cat "${CMD_RUN_RECORDING_FILE:?}" >> "${commit_msg_file}"
  echo '```' >> "${commit_msg_file}"
  echo "" >> "${commit_msg_file}"


  cd "${GT_SANDBOX_REPO:?}" || return 1
  git add . || return 1
  git commit --file=${commit_msg_file} || return 1
  echo.green "Successfully ran command and committed changes with second commit."

  cat "${commit_msg_file}" | copy_announce

  cd "${start_dir}" || return 1
}

gt.snapshot() {
  gt.sandbox.snapshot.run "$@" || return 1
}
export -f gt.snapshot

gt.print.currentCommitToCheckout(){
  # Get current commit hash
  local current_commit_hash="$(git rev-parse --short HEAD)"

  _gt.sandbox.set.GT_SANDBOX_PREFIXED_PWD

  commit_msg_file="/tmp/glassthought-out.md" || return 1
  echo "" > "${commit_msg_file}"
  # Formulate message of second commit
  echo '```bash' >> "${commit_msg_file}"
  echo "gt.sandbox.checkout.commit ${current_commit_hash:?} \\" >> "${commit_msg_file}"
  echo "&& cd \"${GT_SANDBOX_PREFIXED_PWD:?}\"" >> "${commit_msg_file}"
  echo '```' >> "${commit_msg_file}"

  cat "${commit_msg_file}" | copy_announce
}

gt.snapshot.last-command() {
  local last_cmd="$(history | tail -n 2 | head -n 1 | awk '{$1=""; print $0}')" || return 1

  local last_cmd=$(str.trim "${last_cmd}")

  gt.sandbox.snapshot.run "${last_cmd:?}" || return 1
}
export -f gt.snapshot.last-command



