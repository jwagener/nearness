require File.expand_path('../../lib/thingify', __FILE__)

require 'awesome_print'
doc = Nokogiri::HTML.parse(File.read(ARGV.shift || "fixtures/pages/boris_becker.html"))
thing =  Thingify.parse_wikipedia_doc(doc)

url = "http://en.wikipedia.org/wiki/Boris_Becker"
thing["preview_html"] = Thingify.make_links_absolute(url, thing["preview_html"])

ap thing