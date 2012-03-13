url = "http://" + window.location.host + "/bookmarklet?"

params = {}
if NN_BOOKMARKLET? && NN_BOOKMARKLET.preset?
  params = NN_BOOKMARKLET.preset

params.object_url = window.location.toString()
for key of params
  value = params[key]
  if value != null
    url += key + "=" + encodeURIComponent(value) + "&"

e = document.createElement("iframe")
e.src = url
e.setAttribute("style", "border: 1px solid red; position: fixed; top: 10px; right: 10px; width: 640px; height: 240px;")
document.body.appendChild(e)
