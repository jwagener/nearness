NN.Relation = Backbone.Model.extend
  defaults: ->
    {
      subject: {}
      object:  {}
      subject_url: ""
      object_url:  ""
      creator_url: ""
      predicate:   ""
    }