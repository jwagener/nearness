class ThingsProfileController < ApplicationController
  before_filter :set_format

  def index
    @things = Thing.all

    respond_to do |format|
      format.html
      format.json { render json: Collection.new("things", @things) }
    end
  end

  def show
    @thing = load_thing

    respond_to do |format|
      format.html
      format.json { render json: @thing }
    end
  end

  def relations
    @relations = load_thing.relations
    if params[:predicate].present?
      @relations.select! { |r| r.predicate == params[:predicate] }
    end

    respond_to do |format|
      format.html
      format.json { render json: Collection.new("relations", @relations) }
    end
  end

  private
  def load_thing
    Thing.find_by_url(thing_url)
  end

  def thing_url
    request.env['REQUEST_PATH'].match(%r{(https?://.*)})[1]
  end

  def set_format
    request.format = params[:our_format] ||
      if request.env['HTTP_ACCEPT'] =~ /\/json$/
        'json'
      else
        'html'
      end
  end
end
