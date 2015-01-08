# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
ZeroClipboard.config forceHandCursor: true
client = new ZeroClipboard($('button[data-clipboard-text]'))
# client.on 'ready', (event) ->
# 	client.on 'copy', (event) ->
# 		event.clipboardData.setData 'text/plain', event.target.data['clipboard-text']
$('[data-toggle="popover"]').popover()
