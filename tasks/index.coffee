[ # Specify tasks to load
  "config"
  "watch"
  "coffee"
  "packageJson"
  "mdExtract"
].forEach (task) -> require "./#{task}"