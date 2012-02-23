window.NN ||= {
  get: (path, callback) -> 
    $.ajax
      url: path
      dataType: "json"
      success: (data) ->
        callback(data)

  post: (path, data, callback) ->
    $.ajax
      url: path
      dataType: "json"
      type: "POST"
      data: data
      success: (data) ->
        callback(data)

  getThing: (url, callback) ->
    this.get url, callback

  getThingRels: (url, callback) ->
    this.get "/rels" + url, callback
}

NN.AppView = Backbone.View.extend
  el: $("#page")
  events:
    "click .showBookmarklet": "showBookmarklet"
  initialize: ->
    currentThingUrl = window.location.pathname
    NN.getThing currentThingUrl, (response) ->
      if response.things
        for thing in response.things
          thingView = new NN.MiniThingView({model: new NN.Thing(thing)})
          $(".things").append(thingView.render().el)
      else
        thing = new NN.Thing response.thing
        recentThings.addRecent(thing)
        thingView = new NN.ThingView({model: thing})
        $("#thing").append(thingView.render().el)
        $("body").css("backgroundImage", "url(" + thing.get("image_url") + ")");
        document.title = thing.get("name") + " - Nearness"
        NN.getThingRels currentThingUrl, (response) ->
          console.log(response)
  getRecentThings: () ->
    recentThingAttributes = (window.localStorage && window.localStorage.getItem("recentThings")) || []
    recentThings = []
    for attrs in recentThingAttributes
      recentThings.push new NN.Thing(attrs)
    recentThings

  addToRecentThings: (thing) ->
    recentThings = getRecentThings()
    recentThings.push(thing)
    recentThings # limit to 5
    recentThings # serialize and store
  showBookmarklet: (e) ->
    e.preventDefault()
    if !this.bookmarkletView
      this.bookmarkletView = new NN.BookmarkletView
      this.$el.append(this.bookmarkletView.render().el)
    this.bookmarkletView.$el.show();

$ ->
  NN.RecentThingList = Backbone.Collection.extend
    models: []
    model: NN.Thing
    initialize: ->
      this.loadFromLocalStorage()
    loadFromLocalStorage: ->
      rawThings = JSON.parse(localStorage.getItem("recentThings") || "[]")
      this.reset()
      for rawThing in rawThings
        this.add new NN.Thing(rawThing)
    saveToLocalStorage: ->
      localStorage.setItem("recentThings", JSON.stringify(this.toJSON()))
    limitTo: (i) ->
      if this.length > i
        this.reset(this.last(i))
    addRecent: (thing) ->
      this.add(thing)
      # enforce uniqnuess
      this.limitTo(5)
      this.saveToLocalStorage()
  window.recentThings = new NN.RecentThingList()

Backbone.sync = (method, model) ->
  NN.post "/rels", {relation: model.toJSON()}, (savedModel) ->
    console.log(savedModel)

$ ->
  NN.AppView.prototype.el = $("#page")
  window.App = new NN.AppView

  window.testThings = []
  testThings.push new NN.Thing
    url: "http://en.wikipedia.org/wiki/Frida_Kahlo"
    name: "Frida Kahlo"
    image_url: "http://www.hovied.com/wp-content/uploads/2010/07/frida-kahlo-biography.jpg"
    preview_html: "Frida Kahlo is a kick ass girl"

  testThings.push new NN.Thing
    url: "http://en.wikipedia.org/wiki/Day_of_the_Dead"
    name: "Dia de los Muertos"
    image_url: "http://upload.wikimedia.org/wikipedia/en/7/76/Grim_Fandango_artwork.jpg"
    preview_html: "Dia de los Muertos is scary shit"
