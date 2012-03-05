url = "http://localhost:3000/bookmarklet"
e = document.createElement("iframe")
e.src = url
e.setAttribute("style", "border: 1px solid red; position: fixed; top: 10px; right: 10px; width: 640px; height: 240px;")
document.body.appendChild(e)
