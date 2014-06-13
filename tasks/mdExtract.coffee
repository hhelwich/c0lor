
# Imports
gulp = require "gulp"
fs = require "fs"
mkdirp = require "mkdirp"
esprima = require "esprima"

config = require "./config"

#TODO use node stream api
#TODO make gulp plugin instead of task?


separator = "\n// ---------------------------------------------------------------------------------------------------------------------\n"

header = (text) ->
  pos = Math.floor (separator.length - text.length) / 2
  (separator.substring 0, pos) + text + (separator.substring pos + text.length)

extractVars = (node, vars, declaration) ->
  switch node.type
    when "Program"
      for child in node.body
        extractVars child, vars
    when "VariableDeclaration"
      for dec in node.declarations
        extractVars dec, vars
    when "VariableDeclarator"
      extractVars node.id, vars, true
      if node.init?
        extractVars node.init, vars
    when "MemberExpression"
      extractVars node.object, vars
    when "Identifier"
      vars[node.name] = vars[node.name] == true || declaration == true
    when "CallExpression"
      extractVars node.callee, vars
      for arg in node.arguments
        extractVars arg, vars
    when "ExpressionStatement"
      extractVars node.expression, vars
    when "AssignmentExpression"
      extractVars node.left, vars
      extractVars node.right, vars
    when "BinaryExpression"
      extractVars node.left, vars
      extractVars node.right, vars
    when "ForStatement"
      extractVars node.init, vars
      extractVars node.test, vars
      extractVars node.update, vars
      extractVars node.body, vars


getVars = (ast) ->
  vars = {}
  extractVars ast, vars
  vars

gulp.task "mdExtract", ->

  files = ["./README.md"]


  for file in files

    destDir = config.dir.testJS


    fs.readFile file, encoding: "utf8", (err, data) ->

      rexp = /```javascript([^`]*)/g

      outJs = "module.exports = [\n"

      # extract snippets array
      snippets = while (myArray = (rexp.exec data)) != null
        myArray[1]


      snippets = snippets.map (snippet, i) ->
        snippet = snippet.replace "require", "_require"

        vars = getVars esprima.parse snippet
        allVars = Object.keys vars

        undeclared = []
        for v of vars
          if not vars[v]
            undeclared.push v

        out = "function(#{if allVars.length > 0 then "_" else ""}){"

        # declare undeclared variables
        if undeclared.length > 0
          out += "var #{undeclared.join ","};"
        # initialize variables
        if allVars.length > 0
          out += "if(_!=null){"
          out += (allVars.map (v) ->
            "#{v}=_.#{v};").join ""
          out += "}"

        out += header " Snippet #{i} "

        out += snippet

        out += separator
        out += "return{#{allVars.map (v) -> "#{v}:#{v}"}};}"

      outJs += snippets.join ","


      outJs += "];\n"

      dir = "#{config.dir.testJS}/md";
      mkdirp dir, (err) ->
        if err
          console.error err
        else
          fs.writeFile "#{dir}/#{file}.js", outJs, (err) ->
            if err
              console.error err
            #TODO no notification on success (task also needs callback param)
