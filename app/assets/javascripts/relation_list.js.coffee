$ ->
  NN.RelationList = Backbone.Collection.extend
    models: []
    model: NN.Relation
    getRelatedThings: (url) ->
      things = new NN.ThingList
      this.each (thing) ->
        if thing.get("object").url == url
          things.add new NN.Thing(thing.get("subject"))
        else
          things.add new NN.Thing(thing.get("object"))
      things


