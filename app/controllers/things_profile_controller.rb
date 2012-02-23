class ThingsProfileController < ApplicationController
  before_filter :set_format

  def index
    @things = Thing.all

     respond_to do |format|
       format.html { render template: "frontend/index" }
       format.json { render json: Collection.new("things", @things) }
     end
  end

  def show
    respond_to do |format|
      format.html { render template: "frontend/index" }
      format.json do
        @thing = load_or_create_thing!
        render json: @thing
      end
    end
  end

  def relations
    @relations = load_thing!.relations(params[:predicate])

    respond_to do |format|
      format.html
      format.json { render json: Collection.new("relations", @relations) }
    end
  end

  def create_relation
    #relationAttributes = params.slice(:subject_url, :predicate, :object_url)
    relation = Relation.create!(params[:relation])
    render json: relation.as_json
  end

  private
  def load_thing!
    Thing.find_by_url!(thing_url)
  end

  def load_or_create_thing!
    @thing = Thing.find_or_create_by_url(thing_url)
  end

  def thing_url
    request.env['REQUEST_PATH'].match(%r{(https?://.*)})[1]
  end

  def set_format
    request.format = params[:our_format] ||
      if request.env['HTTP_ACCEPT'] =~ /\/json/
        'json'
      else
        'html'
      end
  end
end
