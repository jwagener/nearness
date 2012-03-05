module ApplicationHelper

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
end
