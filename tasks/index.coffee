[ # Specify tasks to load
  "config"
  "watch"
  "coffee"
].forEach (task) -> require "./#{task}"