window.NN ||= {
  get: (path, params, callback) ->
    if !callback?
      callback = params
      params = {}
    url = new URI(path)
    url.query = params
    $.ajax
      url: url.toString()
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
    this.get "/" + encodeURIComponent(url), callback

  getThingRels: (url, callback) ->
    this.get "/" + encodeURIComponent(url) + "/rels", callback

  searchThingCache: {}
  searchThing: (t, callback) ->
    NN.get "/things.json", {t: t}, (response) =>
      callback(response)
}

Backbone.sync = (method, model) ->
  NN.post "/", {relation: model.toJSON()}, (savedModel) ->
    1

$ ->
  NN.AppView = Backbone.View.extend
    thing: null
    el: $("#page")
    events: {}
    initialize: ->
      window.recentThings = new NN.RecentThingList()
      l = window.location
      currentThingUrl = decodeURIComponent(l.toString().replace(l.protocol + "//" + l.host + "/", "")) #pathname + window.location.search)

      this.bookmarkletView = new NN.BookmarkletView
      if $("body").hasClass("bookmarklet")
        params = new URI(window.location, decodeQuery: true).query
        if params.subject_url? && params.predicate? && params.object_url?
          rel = new NN.Relation params
          rel.save()
          this.$el.html("New Relation created: " + [params.subject_url, params.predicate, params.object_url].join(" "))
        else
          $("input").select()
          this.$el.append(this.bookmarkletView.render().el)
          currentThingUrl = params.subject_url
      else
        this.$el.find("#createRelation").append(this.bookmarkletView.render().el)

      if currentThingUrl
        this.renderThingPage(currentThingUrl)
      else
        this.renderThingsPage()

    renderThingPage: (currentThingUrl) ->
      NN.getThing currentThingUrl, (response) =>
        this.thing = new NN.Thing response.thing
        recentThings.addRecent(this.thing)
        thingView = new NN.ThingView({model: this.thing})
        $("#thing").html(thingView.render().el)
        $("body").css("backgroundImage", "url(" + this.thing.get("image_url") + ")");

        document.title = this.thing.get("name") + " - Nearness"
        NN.getThingRels currentThingUrl, (response) =>
          relations = new NN.RelationList(response.relations)
          things = relations.getRelatedThings(this.thing.get("url"))
          App.thingListView = new NN.ThingListView
            el: this.$el.find("#relations")
            collection: things
          App.thingListView.render()
    renderThingsPage: ->
      NN.get "/things.json", (response) =>
        if response.things
          for thing in response.things
            thingView = new NN.MiniThingView({model: new NN.Thing(thing)})
            $(".things").append(thingView.render().el)

    log: (message) ->
      console.log(arguments)




