$(document).ready ->
  app.init()

  $(".demo svg path").each ->
    $(this).css("stroke-dasharray", $(this)[0].getTotalLength())
    $(this).css("stroke-dashoffset", $(this)[0].getTotalLength())

  $("form").ajaxForm (e) ->
    if e is "error"
      alert "Sir... Please select your SVG first."
    else
      $(".result").html(e)
      console.log e
      # frame = $(".result")
      # doc = frame[0].contentWindow.document;
      # body = $('body',doc);
      # body.html(e);

      $(".result svg path, .result svg text, .result svg polygon, .result svg rect").each ->
        $(this).css("stroke-dasharray", $(this)[0].getTotalLength() + "px")
        $(this).css("stroke-dashoffset", $(this)[0].getTotalLength() + "px")
        app.paths += "&nbsp;&nbsp;&#" + $(this).attr("id") + " {<br />&nbsp;&nbsp;&nbsp;&nbsp;stroke-dasharray: " + $(this)[0].getTotalLength() + "px;<br />&nbsp;&nbsp;&nbsp;&nbsp;stroke-dashoffset: " + $(this)[0].getTotalLength() + "px;<br />&nbsp;&nbsp;}<br />"
      $("form").hide()
      $(".result-box").fadeIn()
      $("html,body").animate
        scrollTop: $("#result").offset().top
      app.update_code()


app =
  width: "2"
  color: "#1abc9c"
  duration: "5"
  loop: true
  rounded: "round"
  paths: ""
  keyframes: "<br /><br />@keyframes draw {<br />&nbsp;&nbsp;to {<br />&nbsp;&nbsp;&nbsp;&nbsp;stroke-dashoffset: 0;<br />&nbsp;&nbsp;}<br />}"

  init: ->
    @bind_events()

  bind_events: ->
    # Stroke-Width
    $(document).on "change", ".control-width", (e) ->
      $(".result svg path").css "stroke-width", $(this).val()
      app.width = $(this).val()
      $(".width-info").text(app.width)
      app.update_code()

    # Stroke-Color
    $(document).on "change", ".control-color", (e) ->
      $(".result svg path").css "stroke", $(this).val()
      app.color = $(this).val()
      $(".color-info").text(app.color)
      app.update_code()

    # Duration
    $(document).on "change", ".control-duration", (e) ->
      $(".result svg path").css "animation-duration",$(this).val() + "s"
      app.duration = $(this).val()

      $(".result").hide().fadeIn(1)

      $(".time-info").text(app.duration + "s")
      app.update_code()

    # Loop
    $(document).on "change", ".control-loop", (e) ->
      if $(this).is(":checked")
        $(".result svg path").css "animation-iteration-count", "infinite"
        $(".result svg path").css "animation-fill-mode", "none"
        app.loop = true
      else
        $(".result svg path").css "animation-iteration-count", "1"
        $(".result svg path").css "animation-fill-mode", "forwards"
        app.loop = false
      $(".result").hide().fadeIn(1)
      app.update_code()

    # Rounded Lines
    $(document).on "change", ".control-rounded", (e) ->
      if $(this).is(":checked")
        $(".result svg path").css "stroke-linecap", "round"
        app.rounded = "round"
      else
        $(".result svg path").css "stroke-linecap", "butt"
        app.rounded = "butt"
      $(".result").hide().fadeIn(1)
      app.update_code()

  update_code: ->
    animation = "&nbsp;&nbsp;animation-name: draw;<br />&nbsp;&nbsp;animation-duration: " + @duration + "s;<br />&nbsp;&nbsp;animation-timing-function: linear;"
    if @loop
      animation += "<br />&nbsp;&nbsp;animation-iteration-count: infinite;<br />&nbsp;&nbsp;animation-fill-mode: none;"
    else
      animation += "<br />&nbsp;&nbsp;animation-iteration-count: 1;<br />&nbsp;&nbsp;animation-fill-mode: forwards;"
    $(".code").html "svg path, svg text, svg rect, svg polygon {<br />&nbsp;&nbsp;fill-opacity: 0;<br />&nbsp;&nbsp;stroke: " + @color + ";<br />&nbsp;&nbsp;stroke-width: " + @width + ";<br />&nbsp;&nbsp;stroke-linecap: " + @rounded + ";<br />" + animation + "<br />" + @paths + "}" + @keyframes



