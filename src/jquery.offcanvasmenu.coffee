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

  transformPosition = if settings.direction is "left" then "70%" else "-70%"
  menuLeft = if settings.direction is "left" then "-70%" else "100%"
  transitionCSS = "<style>
    body.off-canvas-menu .outer-wrapper {
      left: 0;
      overflow-x: hidden;
      position: absolute;
      top: 0;
    }
    body.off-canvas-menu .inner-wrapper {
      position: relative;
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
      if body.hasClass("menu-open") is true
        actions.hide()
      else
        actions.show()

    show: () ->
      height = Math.max menu.height(), body.height(), $(window).height()
      outerWrapper.add(innerWrapper).css "height", height 
      if height > menu.height()
        menu.css "height", height 
      actions.animate transformPosition
      body.addClass "menu-open"

    hide: () ->
      actions.animate 0
      body.removeClass "menu-open"

    animate: (position) ->
      if Modernizr? and Modernizr.csstransforms and Modernizr.csstransitions
        innerWrapper.css
          transition: "250ms ease"
          transform: "translateX(" + position + ")"
      else
        innerWrapper.animate({ left: position }, 250);

  on: actions.on
  off: actions.off
  toggle: actions.toggle
  show: actions.show
  hide: actions.hide
