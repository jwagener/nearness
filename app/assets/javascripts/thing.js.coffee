NN.Thing = Backbone.Model.extend
  idAttribute: "url"
  defaults: ->
    {
      url: "url"
      name: "name"
      image_url: "image_url"
      preview_html: "preview"
      relations: []
    }