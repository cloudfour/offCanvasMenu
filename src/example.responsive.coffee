jQuery ->
  $ = jQuery
  menuTrigger = $('#menu-trigger')

  menu = $.offCanvasMenu
    direction : 'right'
    coverage : '70%'

  (configureMenus = (display) ->
    switch display
      when 'block' then menu.on()
      when 'none' then menu.off()
      else return
    return
  )(menuTrigger.css 'display')

  menuTrigger.csswatch
    props : 'display'
  .on 'css-change', (event, change) ->
    configureMenus change.display

  FastClick.attach document.body
  
