cd.last-changed-dir(){

  # Get the list of all non-hidden directories within the current directory and its subdirectories
  directories=$(find . -type d ! -name '.*')

  # Initialize variables for the most recent modification time and directory
  most_recent_time=0
  most_recent_dir=""

  # Loop through each directory and check its modification time
  for dir in $directories; do
    # Get the name of the directory, excluding the "./" prefix
    dir_name="${dir#./}"
    # Check if the directory name starts with a dot
    if [[ "$dir_name" == .* ]]; then
      continue  # Skip hidden directories
    fi
    # Get the modification time of the directory
    mod_time=$(stat -f %m "$dir")
    # If the modification time is more recent than the current most recent time, update the variables
    if [ "$mod_time" -gt "$most_recent_time" ]; then
      most_recent_time=$mod_time
      most_recent_dir="$dir"
    fi
  done

  # Change to the most recently modified directory, if one was found
  if [ -n "$most_recent_dir" ]; then
    cd "$most_recent_dir" || return 1

    echo "Changed to the most recently modified directory: $PWD"
  fi
}
