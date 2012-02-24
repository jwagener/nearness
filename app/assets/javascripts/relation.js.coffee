NN.Relation = Backbone.Model.extend
  defaults: ->
    {
      subject_url: ""
      object_url:  ""
      creator_url: ""
      predicate:   ""
    }