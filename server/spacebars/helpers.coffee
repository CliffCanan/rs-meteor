Template.registerHelper 'include', (template, data) ->
	data ?= {}
	Spacebars.toHTML data, Assets.getText(template)
