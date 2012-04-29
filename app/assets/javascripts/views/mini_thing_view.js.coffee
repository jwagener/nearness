NN.MiniThingView = Backbone.View.extend
  tagName: "div"
  #events:
  #  "click .add": "createRelation"

  initialize: ->
    this

  render: ->
    templateHtml = $("#miniThingTemplate").html()
    html = Mustache.to_html(templateHtml, this.model.toJSON())
    this.$el.html(html)
    # weird workaround for broken event binding

    - # this.$el.click (e) =>
    - #   $el = $(e.target).closest(".miniThing")
    - #   if $el.closest("#createRelation").length > 0
    - #     e.preventDefault()
    - #     $el.children().toggle();

    this.$(".add").click (e) =>
      this.createRelation(e)
    this

  createRelation: (e) ->
    e.preventDefault()
    $a = $(e.target).closest("a.relation")
    $a.toggleClass('highlight')
    rel = new NN.Relation
       subject_url:  App.thing.get("url")
       predicate: $("input.predicate").val();
       object_url:  this.model.get("url")
    rel.save()
    App.thingListView.collection.add(this.model)
