module Embedly
  KEY       = "156713c2545811e1a2ec4040d3dc5c07"
  MAX_WIDTH = 400

  def self.get(url)
    HTTParty.get("http://api.embed.ly/1/oembed", :query => {
      :url      => url,
      :key      => KEY,
      :maxwidth => 400,
      :format   => "json",
    }).parsed_response
  end
end
