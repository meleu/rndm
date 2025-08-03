if [[ "${args[--web]}" == 1 ]]; then
  curl \
    --silent \
    --location \
    "https://www.random.org/integers/?num=1&min=0&max=32767&col=1&base=10&format=plain"
else
  echo "$RANDOM"
fi
