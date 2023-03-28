# Given directory and destination file will package all the shell files
# from this directory into a single file.
shell_file_packer.package_dir_into_one_shell(){
  if [[ -z "${1}" ]]; then
    echo "First argument should be a directory containing shell files"
    return 1
  fi
  if [[ -z "${2}" ]]; then
    echo "Second argument should be destination shell file."
    return 1
  fi
  local dir="${1:?}"
  local dst_file="${2:?}"

  echo > "${dst_file:?}"

  shopt -s globstar
  for filePath in "${dir}"/**/*.sh; do
    echo "# --------------------------------------------------------------------------------" >> "${dst_file:?}"
    echo "# Packaging: $(basename ${filePath:?}) (into this single file):" >> "${dst_file:?}"
    echo "" >> "${dst_file:?}"
    cat "${filePath:?}" >> "${dst_file:?}"

  done
  echo "Done packaging ${dir:?} into ${dst_file:?}"
}
