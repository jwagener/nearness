$ ->
  NN.RecentThingList = Backbone.Collection.extend
    models: []
    model: NN.Thing
    initialize: ->
      this.loadFromLocalStorage()
    loadFromLocalStorage: ->
      rawThings = JSON.parse(localStorage.getItem("recentThings") || "[]")
      this.reset(rawThings)
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
