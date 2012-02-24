NN.BookmarkletView = Backbone.View.extend
  tagName: "div"

  events:
    "click input#term":  "selectAllTerm"
    "keydown input#term": "changeTerm"
    "change input#term": "changeTerm"
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

  changeTerm: (e) ->
    e.preventDefault() if e.type != "keydown"
    console.log(e)

  selectAllTerm: (e) ->
    e.target.select()


