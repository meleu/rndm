max_number="${args[--max]}"
min_number="${args[--min]}"

if [[ "${args[--web]}" == 1 ]]; then
  curl \
    --silent \
    --location \
    "https://www.random.org/integers/?num=1&min=${min_number}&max=${max_number}&col=1&base=10&format=plain"
else
  range=$((max_number - min_number + 1))
  echo $((RANDOM % range + min_number))
fi
