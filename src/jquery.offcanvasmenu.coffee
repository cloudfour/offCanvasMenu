$ = jQuery
$.offCanvasMenu = (options) ->
  settings =
    direction: "left"
    menu     : "#menu"
    trigger  : "#menu-trigger"
    duration : 250
    coverage : "70%"    # Treated as string (units should be included)

  settings = $.extend settings, options

  cssSupport = (Modernizr? and Modernizr.csstransforms and Modernizr.csstransitions)
  # This slightly-fragile hack is to get certain Androids to play well
  transformPrefix = Modernizr.prefixed('transform').replace(/([A-Z])/g, (str,m1) -> return '-' + m1.toLowerCase()).replace(/^ms-/,'-ms-') if cssSupport

  head    = $(document.head)
  body    = $("body")
  trigger = $(settings.trigger)
  menu    = $(settings.menu)

  transformPosition = if settings.direction is "left" then settings.coverage else "-" + settings.coverage
  menuLeft          = if settings.direction is "left" then "-" + settings.coverage else "100%"
  baseCSS = "<style>
    body.off-canvas-menu .outer-wrapper {
      left: 0;
      overflow-x: hidden;
      position: absolute;
      top: 0;
      width: 100%;
    }
    body.off-canvas-menu .inner-wrapper {
      position: relative;
    }
    body.off-canvas-menu " + settings.menu + " {
      left: " + menuLeft + ";
      margin: 0;
      position: absolute;
      top: 0;
      width: " + settings.coverage + ";
    }
  </style>"
  head.append baseCSS

  body.children().wrapAll "<div class=\"outer-wrapper\" />"
  outerWrapper = $(".outer-wrapper")
  outerWrapper.children().wrapAll "<div class=\"inner-wrapper\" />"
  innerWrapper = $(".inner-wrapper")

  actions =
    on: () ->
      body.addClass "off-canvas-menu"
      trigger.on "touchstart mousedown", (e) ->
        e.preventDefault()
        actions.pauseClicks()
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
      actions.setHeights()
      actions.animate transformPosition
      $(window).on "resize", actions.setHeights
      body.addClass "menu-open"

    hide: () ->
      actions.animate 0
      $(window).off "resize"
      body.removeClass "menu-open"

    animate: (position) ->
      if cssSupport
        innerWrapper.css
          transition: transformPrefix + " " + settings.duration + "ms ease"
          transform: "translateX(" + position + ")"
        # TODO: This would be better addressed by listening for the [vendor]transitionend event
        if !position then setTimeout actions.clearHeights, settings.duration
      else
        innerWrapper.animate({ left: position }, settings.duration, if !position then actions.clearHeights else null)

    setHeights: () ->
      actions.clearHeights()
      height = Math.max $(window).height(), $(document).height()
      outerWrapper.add(innerWrapper).css "height", height 
      if height > menu.height()
        menu.css "height", height

    clearHeights: () ->
      outerWrapper.add(innerWrapper).add(menu).css "height", ""

    pauseClicks: () ->
      body.on "click", (e) ->
        e.preventDefault()
        e.stopPropagation()
      setTimeout (() -> body.off "click"), settings.duration * 2

  on    : actions.on
  off   : actions.off
  toggle: actions.toggle
  show  : actions.show
  hide  : actions.hide
