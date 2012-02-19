class Thing < ActiveRecord::Base
  before_create :thingify
  before_create :urify

  def thingify
    self.attributes = Thingify.get(url)
  end

  def urify
    self.uri ||= url
  end
end
