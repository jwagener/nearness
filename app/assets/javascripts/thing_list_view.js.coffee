$ ->
  NN.ThingListView = Backbone.View.extend
    tagName: "ul"
    render: ->
      this.collection.each (thing) =>
        view = new NN.MiniThingView
          model: thing
        this.$el.append(view.render().el)
      this
