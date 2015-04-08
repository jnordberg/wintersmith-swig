
swig = require 'swig'
path = require 'path'
fs = require 'fs'

module.exports = (env, callback) ->

  class SwigTemplate extends env.TemplatePlugin

    constructor: (@tpl) ->

    render: (locals, callback) ->
      try
        callback null, new Buffer @tpl(locals)
      catch error
        callback error

  firstCompile = true
  SwigTemplate.fromFile = (filepath, callback) ->
    if firstCompile
      swig.setDefaults
        loader: swig.loaders.fs(env.templatesPath)
        cache: false
        autoescape: false
      firstCompile = false
    fs.readFile filepath.full, (error, contents) ->
      if error then callback error
      else
        try
          tpl = swig.compile contents.toString(),
            filename: filepath.relative
          callback null, new SwigTemplate tpl
        catch error
          callback error

  env.registerTemplatePlugin '**/*.html', SwigTemplate
  callback()
