NN.BookmarkletView = Backbone.View.extend
  tagName: "div"
  initialize: () ->
    templateHtml = $("#bookmarkletTemplate").html()
    html = Mustache.to_html(templateHtml, {})
    this.$el.html(html)
    console.log(this.$el.find(".results"))

    recentThings.each (thing) =>
      this.addResult(thing)


  clearResults: ->
    this.$el.find(".results").html()

  addResult: (thing) ->
    #relationView = new NN.RelationView model: relation
    templateHtml = $("#miniThingTemplate").html()
    html = Mustache.to_html(templateHtml, thing.toJSON())
    this.$el.find(".results").append(html)



