NN.BookmarkletView = Backbone.View.extend
  tagName: "div"

  events:
    "click input#term":  "selectAllTerm"
    #"keydown input#term": "changeTerm"
    "change input#term": "changeTerm"

  render: ->
    templateHtml = $("#bookmarkletTemplate").html()
    html = Mustache.to_html(templateHtml, {})
    this.$el.html(html)

    this.thingListView = new NN.ThingListView
      el: this.$el.find(".results")
      collection: recentThings
    this.thingListView.render()
    this

  clearResults: ->
    this.$el.find(".results").html()

  changeTerm: (e) ->
    e.preventDefault() if e.type != "keydown"
    term = $(e.target).val()
    bookmarkletView = this
    NN.searchThing term, (response) ->
      thingList = new NN.ThingList(response.things)
      bookmarkletView.thingListView.collection = thingList
      bookmarkletView.thingListView.render()

  selectAllTerm: (e) ->
    this.$el.find(".recent").fadeIn("fast")
    e.target.select()


