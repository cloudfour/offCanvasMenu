$ = if jQuery? then jQuery else Zepto
$.offCanvasMenu = (options) ->
  settings =
    direction: "left"
    coverage : "70%"    # Treated as string (units should be included)
    menu     : "#menu"
    trigger  : "#menu-trigger"
    duration : 250
    # Settings after this are here for conflict avoidance but shouldn't need to be tweaked
    container: 'body'
    classes:
      inner    : 'inner-wrapper'
      outer    : 'outer-wrapper'
      container: 'off-canvas-menu'
      open     : 'menu-open'
    transEndEventNames:
      'WebkitTransition' : 'webkitTransitionEnd'
      'MozTransition'    : 'transitionend'
      'OTransition'      : 'oTransitionEnd otransitionend'
      'msTransition'     : 'MSTransitionEnd'
      'transition'       : 'transitionend'
  settings = $.extend settings, options

  # If we're using jQuery and Modernizr is available, detect CSS support
  cssSupport = (!Zepto? and Modernizr? and Modernizr.csstransforms and Modernizr.csstransitions)
  # If CSS is supported, determine vendor-specific prefix and event names
  if cssSupport
    transformPrefix = Modernizr.prefixed('transform').replace(/([A-Z])/g, (str,m1) -> return '-' + m1.toLowerCase()).replace(/^ms-/,'-ms-')
    # Get the transition end event based on the transition prefix property
    transEndEventName = settings.transEndEventNames[Modernizr.prefixed 'transition']

  head    = $('head')
  body    = $(settings.container)
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
      -webkit-backface-visibility: hidden;
    }
    " + container + " " + settings.menu + " {
      display : block;
      height  : 0;
      left    : " + menuLeft + ";
      margin  : 0;
      overflow: hidden;
      position: absolute;
      top     : 0;
      width   : " + settings.coverage + ";
    }
  </style>"
  head.append baseCSS

  # Excluding scripts solves Zepto bug with wrapAll/wrapInner on body
  body.children(':not(script)').wrapAll '<div class="' + settings.classes.outer + '"/>'
  outerWrapper = $("." + settings.classes.outer)
  outerWrapper.wrapInner '<div class="' + settings.classes.inner + '"/>'
  innerWrapper = $("." + settings.classes.inner)

  actions =
    on: () ->
      if window.location.hash == settings.menu
        # On the off chance the menu is activated when the browser is
        # pointing at the hash target for the menu element, we need
        # to rectify that or the menu will not close properly. This is
        # an uncommon state.
        window.location.hash = ''
      # Remove the possibility of the trigger containing hrefs with hashes
      trigger.find("a").add(trigger).each ->
        $(@).data "href", $(@).attr("href")
        $(@).attr "href", ""
      body.addClass settings.classes.container
      trigger.on "click", (e) ->
        e.preventDefault()
        actions.pauseClicks() if (cssSupport || Zepto?)
        actions.toggle()

    off: () ->
      trigger.find("a").add(trigger).each ->
        $(@).attr "href", $(@).data("href")
        $(@).data "href", ""
      actions.hide()
      body.removeClass settings.classes.container
      trigger.off "click"
      # Make sure we unbind transitionend events
      innerWrapper.off transEndEventName if cssSupport
      # Make sure heights are cleared (esp. important for responsive sites)
      actions.clearHeights()

    toggle: () ->
      unless $(container).length then return false
      if body.hasClass(settings.classes.open) is true
        actions.hide()
      else
        actions.show()

    show: () ->
      unless $(container).length then return false
      actions.setHeights()
      actions.animate transformPosition
      $(window).on "resize", actions.setHeights
      body.addClass settings.classes.open

    hide: () ->
      unless $(container).length then return false
      actions.animate 0
      $(window).off "resize"
      body.removeClass settings.classes.open

    animate: (position) ->
      animationCallback = actions.clearHeights if !position
      if Zepto?
        innerWrapper.animate "translateX": position, settings.duration, "ease", animationCallback
      else if cssSupport
        innerWrapper.css
          transition: transformPrefix + " " + settings.duration + "ms ease"
          transform: "translateX(" + position + ")"
        if !position then innerWrapper.on transEndEventName, () ->
          actions.clearHeights()
          innerWrapper.off transEndEventName
      else
        innerWrapper.animate left: position, settings.duration, animationCallback

    setHeights: () ->
      actions.clearHeights()
      # scrollHeight is to account for Zepto/jQuery inconsistencies
      height = Math.max $(window).height(), $(document).height(), body.prop('scrollHeight')
      outerWrapper.css "height", height
      innerWrapper.css "height", height if height > innerWrapper.height()
      menu.css "height", height if height > menu.height()

    clearHeights: () ->
      outerWrapper.add(innerWrapper).add(menu).css "height", ""

    # Briefly blocks click events from firing (Android 4.2.x bug)
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
