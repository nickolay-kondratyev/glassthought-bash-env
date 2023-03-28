str.urlencode() {
  printf %s "${1}" | jq -sRr @uri
}

str.trim() {
  if [[ -z "${1}" ]]; then
    print.green "${FUNCNAME[0]}"
    echo ": trims the leading and trailing whitespace from a string"
    echo ""
    echo "NO-OP. Example call:"
    echo.green "${FUNCNAME[0]} 'some string'"
    return 1
  fi

  local my_string="${*:?}"

  # #chatGpt
  local trimmed_string="$(echo -e "${my_string}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

  echo "${trimmed_string}"
}

