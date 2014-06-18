$(document).ready ->
  app.init()

  # Apply stroke length details to demo
  $(".demo svg path").each ->
    $(this).css("stroke-dasharray", $(this)[0].getTotalLength())
    $(this).css("stroke-dashoffset", $(this)[0].getTotalLength())

  # Handle SVG upload
  $("form").ajaxForm (e) ->
    if e is "error"
      alert "Sir... Please select your SVG first."
    else
      # Apply result SVG
      $(".result").html(e)

      # Loop through each path and apply stroke length details
      $(".result svg path, .result svg text, .result svg polygon, .result svg rect").each ->
        $(this).css("stroke-dasharray", $(this)[0].getTotalLength() + "px")
        $(this).css("stroke-dashoffset", $(this)[0].getTotalLength() + "px")
        app.paths += "&nbsp;&nbsp;&#" + $(this).attr("id") + " {<br />&nbsp;&nbsp;&nbsp;&nbsp;stroke-dasharray: " + $(this)[0].getTotalLength() + "px;<br />&nbsp;&nbsp;&nbsp;&nbsp;stroke-dashoffset: " + $(this)[0].getTotalLength() + "px;<br />&nbsp;&nbsp;}<br />"
      
      # Toggle boxes
      $("form").hide()
      $(".result-box").fadeIn()

      # Scroll to result
      $("html,body").animate
        scrollTop: $("#result").offset().top

      # Load SASS code
      app.update_code()

# Apllication Object
app =
  width: "2" # Default stroke width
  color: "#1abc9c" # Default stroke color
  duration: "5" # Default animation duration
  loop: true # Default loop state
  rounded: "round" # Default linecap
  paths: "" # Store path information here
  keyframes: "<br /><br />@keyframes draw {<br />&nbsp;&nbsp;to {<br />&nbsp;&nbsp;&nbsp;&nbsp;stroke-dashoffset: 0;<br />&nbsp;&nbsp;}<br />}" # SASS animation

  init: ->
    # Listen for things to happen
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
    # Update SASS code
    $(".code").html "svg path, svg text, svg rect, svg polygon {<br />&nbsp;&nbsp;fill-opacity: 0;<br />&nbsp;&nbsp;stroke: " + @color + ";<br />&nbsp;&nbsp;stroke-width: " + @width + ";<br />&nbsp;&nbsp;stroke-linecap: " + @rounded + ";<br />" + animation + "<br />" + @paths + "}" + @keyframes



