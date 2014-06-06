# create console to log test debug output

charsToReplace =
  "&": "&amp;"
  "<": "&lt;"
  ">": "&gt;"

replaceChar = (tag) ->
  charsToReplace[tag] || tag;

safe_tags_replace = (str) ->
  str.replace /[&<>]/g, replaceChar

log =
  if document? # in browser => log to page
    console = document.getElementById "console"
    (message) ->
      console.innerHTML = console.innerHTML + "* " + (safe_tags_replace message) + "<br>";
  else if console? # not in browser but console object available?
    console.log
  else
    -> # no console output

log "Initialized console"

module.exports = log
