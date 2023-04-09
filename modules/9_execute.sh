file.execute.announce() {
  local file="$1"

  if [[ ! -f "${file}" ]]; then
    echo "${FUNCNAME[0]}: file=${file} does NOT exist. Exiting."
    return 1
  fi

  if [[ -z "${file}" ]]; then
    echo "${FUNCNAME[0]}: file=${file} is empty. Exiting."
    return 1
  fi

  echo "File ${file} contents are:"
  echo "--------------------------------------------------------------------------------"
  cat "${file}"
  echo "--------------------------------------------------------------------------------"
  echo "Executing file=${file}"
  echo "--------------------------------------------------------------------------------"
  "${file}"
  echo "--------------------------------------------------------------------------------"
  echo "Done executing file=${file}"

}

export CMD_RUN_RECORDING_FILE="/tmp/cmd_run_recording.txt"

# Record in a file.
cmd.run.announce.record() {
  local cmd="$*"

  printf "> "
  echo.green "$cmd"

  result=$(eval $cmd)
  return_code=$?

  # echo -e: enable interpretation of backslash escapes
  echo -e "${result}"
  echo -e "${result}" > "${CMD_RUN_RECORDING_FILE}"

  return $return_code
}

cmd.run.announce() {
  local cmd="$*"

  printf "> "
  echo.green "$cmd"

  # If we just try to capture the return code of: eval $cmd
  # we will capture the return code of eval, not the return
  # code of the command. which pretty much always will be 0.
  #
  # Adding local to these variables breaks being able to capture
  # return code from the command.
  result=$(eval $cmd)
  return_code=$?

  # echo -e: enable interpretation of backslash escapes
  echo -e "${result}"

  return $return_code
}
export -f cmd.run.announce
