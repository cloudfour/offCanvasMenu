$ = jQuery
$.offCanvasMenu = (options) ->
  settings =
    direction: "left"
    menu     : "#menu"
    trigger  : "#menu-trigger"
    duration : 250
    coverage : "70%"    # Treated as string (units should be included)
    # Settings after this are here for conflict avoidance but shouldn't need to be tweaked
    container: 'body'
    classes:
      inner    : 'inner-wrapper'
      outer    : 'outer-wrapper'
      container: 'off-canvas-menu'
      open     : 'menu-open'
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
  container         = settings.container + "." + settings.classes.container
  inner             = container + " ." + settings.classes.inner
  outer             = container + " ." + settings.classes.outer

  baseCSS = "<style>
  " + outer + " {
      left: 0;
      overflow-x: hidden;
      position: absolute;
      top: 0;
      width: 100%;
    }
    " + inner + " {
      position: relative;
    }
    " + container + " " + settings.menu + " {
      left    : " + menuLeft + ";
      margin  : 0;
      position: absolute;
      top     : 0;
      width   : " + settings.coverage + ";
    }
  </style>"
  head.append baseCSS

  body.children().wrapAll '<div class="' + settings.classes.outer + '"/>'
  outerWrapper = $("." + settings.classes.outer)
  outerWrapper.children().wrapAll '<div class="' + settings.classes.inner + '"/>'
  innerWrapper = $("." + settings.classes.inner)

  actions =
    on: () ->
      body.addClass settings.classes.container
      trigger.on "touchstart mousedown", (e) ->
        e.preventDefault()
        actions.pauseClicks()
        actions.toggle()

    off: () ->
      body.removeClass settings.classes.container
      actions.hide()
      trigger.off "touchstart mousedown"

    toggle: () ->
      if body.hasClass(settings.classes.open) is true
        actions.hide()
      else
        actions.show()

    show: () ->
      actions.setHeights()
      actions.animate transformPosition
      $(window).on "resize", actions.setHeights
      body.addClass settings.classes.open

    hide: () ->
      actions.animate 0
      $(window).off "resize"
      body.removeClass settings.class.open

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
