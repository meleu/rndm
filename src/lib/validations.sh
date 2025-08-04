validate_positive_integer() {
  local number="$1"

  if ! is_positive_integer "$number"; then
    echo "The argument must be a positive integer. Given value: $number"
  fi
}

is_positive_integer() {
  [[ "$1" =~ ^[1-9][0-9]*$ ]]
}
