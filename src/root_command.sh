max_number="${args[--max]}"

if ! [[ "$max_number" =~ ^[1-9][0-9]*$ ]]; then
  echo "The argument must be a positive integer. Given value: $max_number"
  exit 1
fi

if [[ "${args[--web]}" == 1 ]]; then
  curl \
    --silent \
    --location \
    "https://www.random.org/integers/?num=1&min=0&max=${max_number}&col=1&base=10&format=plain"
else
  echo $((RANDOM % max_number + 1))
fi
