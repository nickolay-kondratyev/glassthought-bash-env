glassthought_env_main() {
  if [[ -z "${GT_BASH_ENV}" ]]; then
    echo "GT_BASH_ENV is not set. Set it to point to path of .../glassthought-bash-env directory "
    return 1
  fi

  for file in "${GT_BASH_ENV:?}"/modules/*; do
    source "$file"
  done


}
glassthought_env_main
