NN.BookmarkletView = Backbone.View.extend
  tagName: "div"
  initialize: () ->
    templateHtml = $("#bookmarkletTemplate").html()
    html = Mustache.to_html(templateHtml, {})
    this.$el.html(html)
    console.log(this.$el.find(".results"))
    this.addResult(testThings[0])
    this.addResult(testThings[1])

  clearResults: ->
    this.$el.find(".results").html()

  addResult: (relation) ->
    console.log(relation)
    #relationView = new NN.RelationView model: relation

    templateHtml = $("#miniThingTemplate").html()
    html = Mustache.to_html(templateHtml, relation.toJSON())
    this.$el.find(".results").append(html)



