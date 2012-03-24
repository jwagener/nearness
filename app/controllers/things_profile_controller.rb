class ThingsProfileController < ApplicationController
  before_filter :set_format

  def index
    limit = 25
    offset = params[:offset].to_i || 0

    if params[:t]
      @things = Thing.find(:all, :conditions => ["name like ?", params[:t]+ "%"], :limit => 5)
    else
      @things = Thing.order("id DESC").limit(limit).offset(offset).all
    end

    next_url = if @things.length >= limit
      url_for(:offset => offset + limit, :format => "json")
    end

    render json: {
      next_url: next_url,
      things: @things.map(&:representation)
    }
  end

  def thing
    @thing = load_or_create_thing!
    render json: @thing
  end

  def relations
    predicate, format = params[:predicate_format].split(".")
    @predicate  = predicate == "rels" ? nil : predicate
    @relations = load_thing!.relations(@predicate)

    if format == "atom"
      render template: "relations/index.atom"
    elsif format == "html"
      render template: "relations/index.html", :layout => false
    else
      render json: Collection.new("relations", @relations)
    end
  end

  def create_relation
    #relationAttributes = params.slice(:subject_url, :predicate, :object_url)
    relation = Relation.create!(params[:relation])
    render json: relation.as_json
  end

private

  def load_thing!
    @thing = Thing.find_by_url!(thing_url)
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
