$ ->

  # embedding soundcloud in bxSlider for IE8 or lower mucks things up, how annoying
  if not $.browser.msie or ($.browser.msie and $.browser.version > 8)
    $("#soundcloud").html "<object height=\"282\" width=\"100%\"> <param name=\"movie\" value=\"http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Fplaylists%2F92329&amp;show_comments=true&amp;auto_play=false&amp;show_playcount=true&amp;show_artwork=true&amp;color=ff7700\"></param> <param name=\"allowscriptaccess\" value=\"always\"></param> <param name=\"wmode\" value=\"transparent\"></param><embed wmode=\"window\" allowscriptaccess=\"always\" height=\"282\" src=\"http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Fplaylists%2F92329&amp;show_comments=true&amp;auto_play=false&amp;show_playcount=true&amp;show_artwork=true&amp;color=ff7700\" type=\"application/x-shockwave-flash\" width=\"100%\"></embed></object></div>"
  else
    $("#soundcloud").html "<h3 style=\"padding-top:40px\">This section does not work in Internet Explorer 8.0 or lower.</h3><p><strong>Please</strong> consider <a href=\"http://windows.microsoft.com/en-US/internet-explorer/products/ie/home\" rel=\"external\">upgrading to Internet Explorer 9</a>.</p><p>If you are running Windows XP, switching to <a href=\"http://chrome.google.com/\" rel=\"external\">Google Chrome</a> or <a href=\"http://www.firefox.com\" rel=\"external\">Mozilla Firefox</a> are both excellent choices that will greatly increase the speed and quality of your browsing!"

  $("#tweets").tweet
    username: "goingslowly"
    join_text: "auto"
    avatar_size: 34
    count: 6
    auto_join_text_default: "we said,"
    auto_join_text_ed: "we"
    auto_join_text_ing: "we were"
    auto_join_text_reply: "we replied to"
    auto_join_text_url: "we were checking out"
    loading_text: "loading tweets..."

  slider =
    controls: true
    auto: false
    autoHover: true
    pause: 6000
    pager: true

  $("#about").bxSlider(slider)
  $("#recents").bxSlider(slider)

  departure = new Date(2013, 3, 1).getTime()
  countdown = ->
    d = 0
    h = 0
    m = 0
    s = 0
    amount = departure - new Date().getTime()
    out = ""
    if amount < 0
      $("#departure").html "NOW :)"
    else
      amount = Math.floor(amount / 1000)
      d = Math.floor(amount / 86400)
      amount = amount % 86400
      h = Math.floor(amount / 3600)
      amount = amount % 3600
      m = Math.floor(amount / 60)
      amount = amount % 60
      s = Math.floor(amount)
      out += d + " day" + ((if (d isnt 1) then "s" else "")) + ", "  if d isnt 0
      out += h + " hour" + ((if (h isnt 1) then "s" else "")) + ", "  if d isnt 0 or h isnt 0
      out += m + " minute" + ((if (m isnt 1) then "s" else "")) + ", "  if d isnt 0 or h isnt 0 or m isnt 0
      out += s + " seconds"
      $("#departure").html "Homesteading in Vermont begins in " + out + "!"
      setTimeout countdown, 1000

  gs.photos.initEffects()

  countdown()
