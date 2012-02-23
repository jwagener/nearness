NN.BookmarkletView = Backbone.View.extend
  tagName: "div"

  render: ->
    templateHtml = $("#bookmarkletTemplate").html()
    html = Mustache.to_html(templateHtml, {})
    this.$el.html(html)

    thingListView = new NN.ThingListView
      el: this.$el.find(".results")
      collection: recentThings
    thingListView.render()

    this

  clearResults: ->
    this.$el.find(".results").html()



