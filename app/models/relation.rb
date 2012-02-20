class Relation < ActiveRecord::Base
  scope :with_predicate, ->(predicate) do
    where("predicate = ?", predicate) if predicate.present?
  end

  def subject
    Thing.find_by_url(subject_url)
  end

  def object
    Thing.find_by_url(object_url)
  end

  def representation
    attributes.slice(*%w[ predicate ]).merge({
      "subject" => subject.representation,
      "object"  => object.representation,
    }).reject { |k,v| v.nil? }
  end

  def as_json(options = nil)
    { "relation" => representation }.as_json(options)
  end
end
