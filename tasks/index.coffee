[ # Specify tasks to load
  "config"
  "watch"
  "coffee"
  "packageJson"
].forEach (task) -> require "./#{task}"