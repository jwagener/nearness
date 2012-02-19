require 'httparty'
require './lib/embedly'

module Thingify
  TRANSLATE =
    {
      "image_url"    => "thumbnail_url",
      "preview_html" => "preview_html",
      "name"         => "title",
    }

  def self.get(url)
    embedly = Embedly.get(url)

    TRANSLATE.inject({}) do |memo, (key, value)|
      memo[key] = embedly[value]
      memo
    end
  end
end
