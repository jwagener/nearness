class ThingsProfileController < ApplicationController
  before_filter :set_format

  def index
    if params[:t]
      @things = Thing.find(:all, :conditions => ["name like ?", params[:t]+ "%"], :limit => 5)
    else
      @things = Thing.all
    end

    render json: Collection.new("things", @things)
  end

  def thing
    @thing = load_or_create_thing!
    render json: @thing
  end

  def relations
    predicate  = params[:predicate] == "rels" ? nil : params[:predicate]
    @relations = load_thing!.relations(predicate)
    render json: Collection.new("relations", @relations)
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
    request_uri = request.env["REQUEST_URI"] || ""

    url =if params[:action] == "relations"
      request_uri.split("/")[3..-2].join("/")
    else
      request_uri.split("/")[3..-1].join("/")
    end
    URI.decode(url)
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
