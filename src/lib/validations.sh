validate_positive_integer() {
  local number="$1"

  if ! is_positive_integer "$number"; then
    echo "The argument must be a positive integer. Given value: $number"
    exit 1
  fi
}

is_positive_integer() {
  [[ "$1" =~ ^[1-9][0-9]*$ ]]
}
