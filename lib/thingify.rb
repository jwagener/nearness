require 'httparty'
require File.expand_path('../embedly.rb', __FILE__)
require 'nokogiri'
module Thingify
  TRANSLATE =
    {
      "image_url"    => "thumbnail_url",
      "preview_html" => "html",
      "name"         => "title",
    }

  def self.get(url)
    if url.match /wikipedia.org/
      get_wikipedia(url)
    else
      get_embedly(url)
    end
  end

  def self.get_parsed_html(url)
    body = HTTParty.get(url).body
    doc = Nokogiri::HTML.parse(body)
  end

  def self.get_wikipedia(url)
    doc = get_parsed_html(url)

    thing = parse_wikipedia_doc(doc)
    thing["preview_html"] = make_links_absolute(url, thing["preview_html"])
    thing
  end

  def self.parse_wikipedia_doc(doc)
    content = doc.css("#bodyContent .mw-content-ltr")[0]
    thing = {}
    thing["name"] = doc.css("#firstHeading")[0].content

    image_srcs = content.css("img").map { |n| n.attr("src") }

    img_src_blacklist = %w[Padlock-silver.svg Padlock-olive.svg Disambig_gray Ambox_content.png Text_document_with_red_question_mark]
    thing["image_url"] = image_srcs.reject { |s| img_src_blacklist.one? { |b| s.include? b } }.first

    thing["preview_html"] = ""
    before_toc = true
    node_name_whitelist = %w[p ul ol]
    content.children.each do |node|
      if node.is_a? Nokogiri::XML::Element
        if before_toc && node_name_whitelist.include?(node.name)
          thing["preview_html"] += node.send :dump_html #"<p>" + node.inner_html + "</p>"
        elsif node.name == "table" && node.attr("id") == "toc"
          before_toc = false
        end
      end
    end

    #thing
    # make urls absolute
    #URI.parse(root).merge(URI.parse(href)).to_s
    thing
  end

  def self.make_absolute( href, root )
    URI.parse(root).merge(URI.parse(href)).to_s
  end


  def self.make_links_absolute(base_url, text)
    text = text.gsub(/href="([^"]*)"/) do |href|
      url = href.match(/href="([^"]*)"/)[1]
      # watch out this is making it relative to nearness!:
      %{href="/#{make_absolute(url, base_url)}"}
    end
    text
  end

  def self.get_embedly(url)
    embedly = Embedly.get(url)
    thing = TRANSLATE.inject({}) do |memo, (key, value)|
      memo[key] = embedly[value]
      memo
    end
    thing
  end
end
