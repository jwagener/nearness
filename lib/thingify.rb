require 'httparty'
require './lib/embedly'

module Thingify
  TRANSLATE =
    {
      "image_url"    => "thumbnail_url",
      "preview_html" => "html",
      "name"         => "title",
    }

  def self.get(url)
    embedly = Embedly.get(url)
    thing = TRANSLATE.inject({}) do |memo, (key, value)|
      memo[key] = embedly[value]
      memo
    end
    if url.match /wikipedia.org/
      thing["name"] = thing["name"].gsub(" - Wikipedia, the free encyclopedia", "")
    end
    thing
  end

end
