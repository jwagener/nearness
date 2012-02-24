NN.MiniThingView = Backbone.View.extend
  tagName: "div"
  events:
    "click #createRelation a.relation": "createRelation"

  initialize: ->
    this

  render: ->
    templateHtml = $("#miniThingTemplate").html()
    html = Mustache.to_html(templateHtml, this.model.toJSON())
    this.$el.html(html)
    this

  createRelation: (e) ->
    e.preventDefault()
    $a = $(e.target)
    $a.toggleClass('highlight')
    rel = new NN.Relation
       subject_url:  App.thing.get("url")
       object_url:  this.model.get("url")
    rel.save()
