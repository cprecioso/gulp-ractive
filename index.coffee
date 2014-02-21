es = require 'event-stream'
{parse} = require 'ractive'
gutil = require 'gulp-util'
{Buffer} = require 'buffer'

module.exports = (opt = {}) ->
	es.through (file) ->
		return this.emit 'data', file if file.isNull()
		return this.emit 'error', new Error 'gulp-ractive: Streaming not supported' if file.isStream()
		
		str = file.contents.toString 'utf8'
		
		ext = if opt.ext? then '.' + opt.ext else '.ract'
		dest = gutil.replaceExtension file.path, ext
		
		options =
			preserveWhitespace: if opt.preserveWhitespace? then !! opt.preserveWhitespace else false
			sanitize: if opt.sanitize? then opt.sanitize else false
		
		try data = parse str, options
		catch error
			return this.emit 'error', new Error error
		
		file.contents = new Buffer data
		file.path = dest
		this.emit 'data', file