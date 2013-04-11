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
    body.off-canvas-menu .inner-wrapper {
      -webkit-transform: translate3d(0, 0, 0);
      -moz-transform: translate3d(0, 0, 0);
      -ms-transform: translate3d(0, 0, 0);
      -o-transform: translate3d(0, 0, 0);
      transform: translate3d(0, 0, 0);
      -webkit-transition: -webkit-transform 250ms ease;
      -moz-transition: -moz-transform 250ms ease;
      -o-transition: -o-transform 250ms ease;
      transition: transform 250ms ease;
      -webkit-backface-visibility: hidden;
      -moz-backface-visibility: hidden;
      -ms-backface-visibility: hidden;
      -o-backface-visibility: hidden;
      backface-visibility: hidden;
    }
    body.off-canvas-menu.menu-open .inner-wrapper {
      -webkit-transform: translate3d(" + transformDistance + ", 0, 0);
      -moz-transform: translate3d(" + transformDistance + ", 0, 0);
      -ms-transform: translate3d(" + transformDistance + ", 0, 0);
      -o-transform: translate3d(" + transformDistance + ", 0, 0);
      transform: translate3d(" + transformDistance + ", 0, 0);
      -webkit-transition: -webkit-transform 250ms ease;
      -moz-transition: -moz-transform 250ms ease;
      -o-transition: -o-transform 250ms ease;
      transition: transform 250ms ease;
      -webkit-backface-visibility: hidden;
      -moz-backface-visibility: hidden;
      -ms-backface-visibility: hidden;
      -o-backface-visibility: hidden;
      backface-visibility: hidden;
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
  $(".outer-wrapper > *").wrapAll "<div class=\"inner-wrapper\" />"

  on: () ->
    body.addClass "off-canvas-menu"
    trigger.on("touchstart mousedown", (e) ->
      e.preventDefault()
      height = Math.max menu.height(), body.height(), $(window).height()
      $(".outer-wrapper, .inner-wrapper").css "height", height 
      if height > menu.height()
        menu.css "height", height 
      body.toggleClass "menu-open"
    )

  off: () ->
    body.removeClass "off-canvas-menu"
    trigger.off "touchstart mousedown"

  show: () ->
    body.addClass "menu-open"

  hide: () ->
    body.removeClass "menu-open"
