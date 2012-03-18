
swig = require 'swig'
path = require 'path'
fs = require 'fs'

module.exports = (wintersmith, callback) ->

  class SwigTemplate extends wintersmith.TemplatePlugin

    constructor: (@tpl) ->

    render: (locals, callback) ->
      try
        callback null, new Buffer @tpl(locals)
      catch error
        callback error

  SwigTemplate.fromFile = (filename, callback) ->
    fs.readFile filename, (error, contents) ->
      if error then callback error
      else
        try
          tpl = swig.compile contents.toString(), filename
          callback null, new SwigTemplate tpl
        catch error
          callback error

  wintersmith.registerTemplatePlugin '**/*.html', SwigTemplate
  callback()
