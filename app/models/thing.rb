class Thing < ActiveRecord::Base
  before_create :thingify
  before_create :urify


  def relations(predicate = nil)
    Relation.with_predicate(predicate).with_url(url).order("id DESC")
  end

  def thingify
    self.attributes = Thingify.get(url)
  end

  def urify
    self.uri ||= url
  end

  def mini_representation
    attributes.slice(*%w[ url name image_url ]).reject { |k,v| v.nil? }
  end

  def local_url
    "/#{CGI.escape(url)}"
  end

  def representation
    r = attributes.slice(*%w[ url name image_url preview_html ]).reject { |k,v| v.nil? }
    r[:local_url] = local_url
    r
  end

  def as_json(options = nil)
    { "thing" => representation }.as_json(options)
  end

  def self.find_or_create_by_url!(url)
    thing = find_by_url(url)
    if thing.nil?
      thing = Thing.new(url: url)
      thing.thingify
      thing.save
    end
    thing
  end
end
