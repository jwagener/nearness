$ ->
  NN.RelationList = Backbone.Collection.extend
    models: []
    model: NN.Relation
    getRelatedThings: (url) ->
      things = new NN.ThingList
      this.each (thing) ->
        if thing.get("object").url == url
          if !things.get(thing.get("subject").url)
            things.add new NN.Thing(thing.get("subject"))
        else
          if !things.get(thing.get("object").url)
           things.add new NN.Thing(thing.get("object"))
      things


