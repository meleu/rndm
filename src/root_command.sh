max_number="${args[--max]}"

validate_positive_integer "$max_number"

if [[ "${args[--web]}" == 1 ]]; then
  curl \
    --silent \
    --location \
    "https://www.random.org/integers/?num=1&min=0&max=${max_number}&col=1&base=10&format=plain"
else
  echo $((RANDOM % max_number + 1))
fi
