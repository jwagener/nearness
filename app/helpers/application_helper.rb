module ApplicationHelper
  def get_related_things_from_relations(url, relations)
    @relations.map do |relation|
      if relation.subject_url == url
        relation.object
      else
        relation.subject
      end
    end
  end

  def link_to_bookmarklet(text, preset={})
    js  = %{javascript:}
    js += %|window.NN_BOOKMARKLET = {preset: #{preset.to_json}};|
    js += %{var s = document.createElement("script");}
    js += %{s.src="#{root_url}assets/bookmarklet.js?" + Math.random();}
    js += %{document.body.appendChild(s);}
    js += %{}
    js += %{}
    js.gsub!('"', "'")
    link_to text, js.html_safe
  end

  def atom_datetime(d)
    d.to_s(:rfc3339).gsub(" ", "T").gsub("TUTC", "Z")
  end
end
