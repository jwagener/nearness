$ ->
  NN.ThingListView = Backbone.View.extend
    tagName: "ul"
    initialize: ->
      this.collection.bind('add', this.render, this);
    render: ->
      this.$el.html("")
      this.collection.each (thing) =>
        view = new NN.MiniThingView
          model: thing
        this.$el.append(view.render().el)
      this
