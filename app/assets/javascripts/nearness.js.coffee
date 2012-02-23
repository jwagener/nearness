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

Backbone.sync = (method, model) ->
  NN.post "/rels", {relation: model.toJSON()}, (savedModel) ->
    console.log(savedModel)

$ ->
  NN.AppView = Backbone.View.extend
    el: $("#page")
    events:
      "click .showBookmarklet": "showBookmarklet"
    initialize: ->
      window.recentThings = new NN.RecentThingList()

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
    showBookmarklet: (e) ->
      e.preventDefault()
      if !this.bookmarkletView
        this.bookmarkletView = new NN.BookmarkletView
        this.$el.append(this.bookmarkletView.render().el)
      this.bookmarkletView.$el.show();



