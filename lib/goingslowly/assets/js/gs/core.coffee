window.gs = gs = window.gs || {}

# google analytics
window._gaq = window._gaq || []
window._gaq.push(["_setAccount", "UA-1653683-4"])
window._gaq.push(["_trackPageview"])

# configure humane loggers
humane.info = humane.spawn({addnCls: "humane-info", timeout: 3500})
humane.error = humane.spawn({addnCls: "humane-error", timeout: 3500})
humane.success = humane.spawn({addnCls: "humane-success", timeout: 3500})

# run on page load for all pages
$ ->
  # initialize autosuggest
  $("#search").autosuggest({data: gs.autosuggest, offsetTop: 32})

  # initialize gsdb tooltip
  $("#gsdb").tipTip(
    defaultPosition: "left"
    content: "<strong class=\"color\">Behind the Scenes:</strong><br/>Statistics, expenses and more."
  ).removeAttr "title"

  # flag external links to open in a new window
  $("a[rel=external],.external").on "click", (e) ->
    window.open @href
    e.preventDefault()

  # ajaxify forms
  $("form.ajax").each ->
    gs.form.init(this)

#  # enable newsletter colorbox
#  $(".nl").colorbox
#    opacity: 0.85
#    href: "/newsletter?popup=true"
#    title: " "
#    scrolling: false
#    height: 525

  # enable kids colorbox
  $("#kids").colorbox
    opacity: 0.75
    href: "/settings"
