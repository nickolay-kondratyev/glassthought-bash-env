# Colors for printing stuff out
# https://unix.stackexchange.com/a/269085/364768
export color_red=$(tput setaf 1)
export color_green=$(tput setaf 2)
export color_yellow=$(tput setaf 3)
export color_blue=$(tput setaf 4)
export color_purple=$(tput setaf 5)
export color_cyan=$(tput setaf 6)
export color_reset=$(tput sgr0)

export underline_on=$(tput smul)
export underline_off=$(tput rmul)

export COLOR_GREEN=${color_green}
export COLOR_YELLOW=${color_yellow}
export COLOR_RESET=${color_reset}

export UNDERLINE_ON=$(tput smul)
export UNDERLINE_OFF=$(tput rmul)

declare_print_funcs(){
  declare -A map_style_to_styleVal

  map_style_to_styleVal["red"]="${color_red:?}"
  map_style_to_styleVal["green"]="${color_green:?}"
  map_style_to_styleVal["yellow"]="${color_yellow:?}"
  map_style_to_styleVal["blue"]="${color_blue:?}"
  map_style_to_styleVal["purple"]="${color_purple:?}"
  map_style_to_styleVal["cyan"]="${color_cyan:?}"
  # map_style_to_styleVal["plain"]=""
  # map_style_to_styleVal["underline"]="${underline_on:?}"

  for style in "${!map_style_to_styleVal[@]}"; do
    local style_val="${map_style_to_styleVal[$style]}"

    eval "echo_${style}() {
      echo \"${style_val}\${@}${color_reset}\"
    }
    export -f echo_${style}

    echo.${style}() {
      echo_${style} \"\${@}\"
    }
    export -f echo.${style}

    print_${style}() {
      echo -n \"${style_val}\${@}${color_reset}\"
    }
    export -f print_${style}

    print.${style}() {
      print_${style} \"\${@}\"
    }
    export -f print.${style}
    "
  done
}
declare_print_funcs


print.plain() {
  echo -n "${@}"
}
export -f print.plain

echo.plain() {
  echo "${@}"
}
export -f echo.plain

