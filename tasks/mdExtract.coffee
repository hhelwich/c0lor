esprima = require "esprima"

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

module.exports = (grunt) ->

  grunt.registerMultiTask "mdExtract", ->

    files = @files.slice()


    for file in files

      destDir = file.dest

      sfiles = file.src.filter (filepath) ->
        # Warn on and remove invalid source files (if nonull was set).
        fileExists = grunt.file.exists filepath
        if not fileExists
          grunt.log.warn "Source file '#{filepath}' not found."
        fileExists

      rexp = /```javascript([^`]*)/g

      for sfile in sfiles # iterate source files

        outJs = "module.exports = [\n"

        str = grunt.file.read sfile

        # extract snippets array
        snippets = while (myArray = (rexp.exec str)) != null
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

        grunt.file.write "#{destDir}/#{sfile}.js", outJs
