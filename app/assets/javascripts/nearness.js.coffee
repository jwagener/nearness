window.NN ||= {
  get: (path, callback) -> 
    $.ajax
      url: path
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
    this.get url, callback

  getThingRels: (url, callback) ->
    this.get "/rels" + url, callback
}

NN.AppView = Backbone.View.extend
  el: $("#page")
  events:
    "click .showBookmarklet": "showBookmarklet"
  initialize: ->
    #currentThingUrl = "http://en.wikipedia.org/wiki/Frida_Kahlo"
    currentThingUrl = window.location.pathname
    NN.getThing currentThingUrl, (response) ->
      console.log(response)
      thing = new NN.Thing response.thing
      thingView = new NN.ThingView({model: thing})
      $("#thing").append(thingView.render().el)
      $("body").css("backgroundImage", "url(" + thing.get("image_url") + ")");

      NN.getThingRels currentThingUrl, (response) ->
        console.log(response)
    console.log("App booted")

  showBookmarklet: (e) ->
    e.preventDefault()
    console.log("yeah")


Backbone.sync = (method, model) ->
  NN.post "/rels", {relation: model.toJSON()}, (savedModel) ->
    console.log(savedModel)

$ ->
  NN.AppView.prototype.el = $("#page")
  window.App = new NN.AppView

testStuff = ->
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
  

