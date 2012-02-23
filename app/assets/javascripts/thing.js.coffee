NN.Thing = Backbone.Model.extend
  defaults: ->
    {
      url: "url"
      name: "name"
      image_url: "image_url"
      preview_html: "preview"
      relations: []
    }