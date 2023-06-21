gt.chatgpt.copy-last-exported-chat(){
  local startDir="$(pwd)"

  cd "/Users/$(whoami)/.chatgpt/notes"

  echo "At $(pwd)"
  local lastChat=$(gt.lastModifiedFileMarkdownFile)
  cat $lastChat | pbcopy

  echo "Copied last chat to clipboard. ($(pwd)/${lastChat})"

  cd "${startDir}" || return 1
}


# LastFile = last modified file in current directory.
gt.lastModifiedFileMarkdownFile() {
  local file=$(ls -tr | grep ".*md" | tail -n 1)

  echo "${file}"
  printf "${file}" | pbcopy
}
