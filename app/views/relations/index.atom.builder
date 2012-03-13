xml.instruct! :xml, version: "1.0" 
xml.feed xmlns: "http://www.w3.org/2005/Atom" do
  xml.title "#{@thing.name}s #{@predicate || "relations"}"
  xml.subtitle "Recent things related to #{@thing.name}"
  xml.updated atom_datetime @relations.first.try(:created_at) || DateTime.now
  xml.link href: url_for, rel: "self"
  xml.link href: root_url[0..-2] + url_for
  xml.id "urn:uuid:60a76c80-d399-11d9-b91C-0003939e0af6"
  xml.author do
    xml.name "Nearness"
  end
  for relation in @relations
    thing = relation.object
    xml.entry do
      xml.title   thing.name
      xml.summary thing.preview_html, type: "html"
      xml.updated atom_datetime(relation.created_at)
      xml.link href: thing.url
      xml.id    thing.url

    end
  end
end