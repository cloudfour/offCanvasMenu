$ = jQuery
$.offCanvasMenu = (options) ->
  settings =
    direction: "left"
    menu: "#menu"
    trigger: "#menu-trigger"
  settings = $.extend settings, options

  head = $(document.head)
  body = $("body")
  trigger = $(settings.trigger)
  menu = $(settings.menu)

  transformDistance = if settings.direction is "left" then "70%" else "-70%"
  menuLeft = if settings.direction is "left" then "-70%" else "100%"
  transitionCSS = "<style>
    body.off-canvas-menu .outer-wrapper {
      overflow-x: hidden;
    }
    body.off-canvas-menu " + settings.menu + " {
      left: " + menuLeft + ";
      margin: 0;
      position: absolute;
      top: 0;
      width: 70%;
    }
  </style>"
  head.append transitionCSS

  body.children().wrapAll "<div class=\"outer-wrapper\" />"
  outerWrapper = $(".outer-wrapper")
  outerWrapper.children().wrapAll "<div class=\"inner-wrapper\" />"
  innerWrapper = $(".inner-wrapper")

  actions =
    on: () ->
      body.addClass "off-canvas-menu"
      trigger.on "touchstart mousedown", (e) ->
        e.preventDefault()
        actions.toggle()

    off: () ->
      body.removeClass "off-canvas-menu"
      actions.hide()
      trigger.off "touchstart mousedown"

    toggle: () ->
      if body.hasClass("menu-open") is false
        actions.show()
      else
        actions.hide()

    show: () ->
      height = Math.max menu.height(), body.height(), $(window).height()
      outerWrapper.css "height", height 
      innerWrapper.css "height", height 
      if height > menu.height()
        menu.css "height", height 
      innerWrapper.css
        transition: "250ms ease"
        transform: "translateX(" + transformDistance + ")"
      body.addClass "menu-open"

    hide: () ->
      innerWrapper.css
        transition: "250ms ease"
        transform: "translateX(0)"
      body.removeClass "menu-open"

  on: actions.on
  off: actions.off
  toggle: actions.toggle
  show: actions.show
  hide: actions.hide
