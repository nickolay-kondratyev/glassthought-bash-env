copy_announce() {
  if [ $# -eq 0 ]; then
    local toCopy="$(cat)"
  else
    local toCopy="$*"
  fi

  if [ -x "$(command -v pbcopy)" ]; then
    echo "$toCopy" | pbcopy

    ## if a single line
    if [[ "$toCopy" == *$'\n'* ]]; then
      echo "copied to clipboard:"
      echo.cyan "$toCopy"
    else
      echo -n "copied to clipboard: "
      echo.cyan "$toCopy"
    fi
  else
    echo.red "pbcopy_announce no-op: nothing copied to clipboard pbcopy command is missing"
    echo "Wanted to copy:"
    echo.yellow "$toCopy"
  fi
}
export -f copy_announce
