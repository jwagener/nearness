NN.RelationView = Backbone.View.extend
  tagName: "div"
  events: {}
  initialize: ->
    this
  render: (preview) ->
    templateHtml = $("#relationTemplate").html()
    templateHtml = templateHtml.replace(/REPLACE_SUB_OBJ/g, preview)
    html = Mustache.to_html(templateHtml, this.model.toJSON())
    this.$el.html(html)
    this