cli.ask_yes_no() {
  if [[ -z "${1}" ]]; then
    print.green "${FUNCNAME[0]}"
    echo ": given prompt. Asks user for yes or no answer."
    echo ""
    echo "NO-OP. Example call:"
    echo.green "${FUNCNAME[0]} \"Do you want to continue?\""
    return 1
  fi

  while true; do
    read -p "${*} (y/n): " yn

    case $yn in
    [Yy]*) return 0 ;;
    [Nn]*) return 1 ;;
    *) echo "Please answer y or n." ;;
    esac
  done
}
