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
    this.get "/.json" + url, callback

  getThingRels: (url, callback) ->
    this.get "/rels.json" + url, callback
}

Backbone.sync = (method, model) ->
  NN.post "/rels", {relation: model.toJSON()}, (savedModel) ->
    console.log(savedModel)

$ ->
  NN.AppView = Backbone.View.extend
    thing: null
    el: $("#page")
    events:
      "click .showBookmarklet": "showBookmarklet"
    initialize: ->
      window.recentThings = new NN.RecentThingList()
      this.bookmarkletView = new NN.BookmarkletView
      this.$el.find("#createRelation").append(this.bookmarkletView.render().el)
      currentThingUrl = window.location.pathname
      NN.getThing currentThingUrl, (response) =>
        if response.things
          for thing in response.things
            thingView = new NN.MiniThingView({model: new NN.Thing(thing)})
            $(".things").append(thingView.render().el)
        else
          this.thing = new NN.Thing response.thing
          recentThings.addRecent(this.thing)
          thingView = new NN.ThingView({model: this.thing})
          $("#thing").append(thingView.render().el)
          $("body").css("backgroundImage", "url(" + this.thing.get("image_url") + ")");
          console.log(this.thing)

          document.title = this.thing.get("name") + " - Nearness"
          NN.getThingRels currentThingUrl, (response) ->
            console.log(response)
    showBookmarklet: (e) ->
      e.preventDefault()
      if !this.bookmarkletView
        this.bookmarkletView = new NN.BookmarkletView
        this.$el.append(this.bookmarkletView.render().el)
      this.bookmarkletView.$el.show();



