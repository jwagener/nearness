NN.Relation = Backbone.Model.extend
  defaults: ->
    {
      subject_url: "surl"
      object_url: "ourl"
      creator_url: "curl"
      predicate: "like"
    }