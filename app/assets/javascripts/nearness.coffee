window.NN ||= {}
NN.Thing = Backbone.Model.extend
  defaults: ->
    {
      url: "url"
      name: "name"
      image_url: "image_url"
      preview_html: "preview"
      relations: []
    }

NN.Relation = Backbone.Model.extend
  defaults: ->
    {
      subject_url: "surl"
      object_url: "ourl"
      creator_url: "curl"
      predicate: "like"
    }
  
NN.ThingView = Backbone.View.extend
  tagName: "div"
  events: {}
  #template: $("#thingTemplate")
  initialize: ->
    this

  render: ->
    templateHtml = $("#thingTemplate").html()
    html = Mustache.to_html(templateHtml, this.model.toJSON())
    this.$el.html(html)
    this

NN.RelationView = Backbone.View.extend
  tagName: "div"
  events: {}
  initialize: ->
    this
  render: ->
    templateHtml = $("#relationTemplate").html()
    html = Mustache.to_html(templateHtml, this.model.toJSON())
    this.$el.html(html)
    this
    
NN.RelationView = Backbone.View.extend
  tagName: "div"
  events: {}
  initialize: ->
    this
  render: (preview) ->
    templateHtml = $("#relationTemplate").html()
    templateHtml = templateHtml.replace(/REPLACE_SUB_OBJ/g, preview)
    html = Mustache.to_html(templateHtml, this.model.toJSON())
    this.$el.html(html)
    this

NN.AppView = Backbone.View.extend
  el: $("#page")
  events: {}
  initialize: ->
    console.log("App booted")

$ ->
  window.App = new NN.AppView

  frida = new NN.Thing
    url: "http://en.wikipedia.org/wiki/Frida_Kahlo"
    name: "Frida Kahlo"
    image_url: "http://www.hovied.com/wp-content/uploads/2010/07/frida-kahlo-biography.jpg"
    preview_html: "Frida Kahlo is a kick ass girl"

  dia = new NN.Thing
    url: "http://en.wikipedia.org/wiki/Day_of_the_Dead"
    name: "Dia de los Muertos"
    #image_url: "http://upload.wikimedia.org/wikipedia/commons/7/7c/Catrinas_2.jpg"
    image_url: "http://upload.wikimedia.org/wikipedia/en/7/76/Grim_Fandango_artwork.jpg"
    preview_html: "Dia de los Muertos is scary shit"

  relation = new NN.Relation
      subject_url: "http://en.wikipedia.org/wiki/Frida_Kahlo"
      object_url:  "http://en.wikipedia.org/wiki/Day_of_the_Dead"
      predicate:   ""
      subject: frida.toJSON()
      object: dia.toJSON()
  
  frida.set("relations", [relation])
  fridaView = new NN.ThingView({model: frida})
  $("#thing").append(fridaView.render().el)
  
  $("body").css("backgroundImage", "url(" + frida.get("image_url") + ")");
  
  relationView = new NN.RelationView model: relation
  $("#relations").append(relationView.render("object").el)

  relationView1 = new NN.RelationView model: relation
  $("#relations").append(relationView1.render("subject").el)
  

