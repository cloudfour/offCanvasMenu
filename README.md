# offCanvasMenu

**offCanvasMenu** is a jQuery/Zepto plugin that provides an easy way to implement an off-canvas toggling menu, a navigation metaphor made popular by mobile applications.

When activated, offCanvasMenu "slides" the menu element into view, "pushing" other content to the side.

## Setup

### 1. Include jQuery (or Zepto)

Our example comes with jQuery 1.9.1 (but 2.0.0 should work as well).

    <script src="lib/jquery-2.0.0.min.js"></script>

If you'd prefer, you can use [Zepto](http://zeptojs.com/) instead.

    <script src="lib/zepto-1.0.min.js"></script>

### 2. Include Modernizr (Optional)

If you're using jQuery but want CSS transitions (Super swank! So much prettier!), you'll need Modernizr. Our example comes with a custom build that only contains the tests needed.

    <script src="lib/modernizr.custom.js"></script>

You can check out our [Modernizr build details](http://modernizr.com/download/#-csstransforms-csstransitions-addtest-prefixed-teststyles-testprop-testallprops-hasevent-prefixes-domprefixes).

**Needed tests** (if you want to add to an existing Modernizr build):

* `csstransforms`
* `csstransitions`

*Note*: Modernizr is optional (and not at all necessary if you're using Zepto). If you don't include it, the plugin will fall back to JS animations.

### 3. Include the plugin

    <script src="lib/jquery.offcanvasmenu.js"></script>

### 4. Initialize your menu!

    $.offCanvasMenu();

#### Options

    $.offCanvasMenu({
      direction : 'left',
      coverage  : '70%',
      trigger   : '#menu-trigger',
      menu      : '#menu',
      duration  : 250,
      container : 'body',
      classes   : {
        inner    : 'inner-wrapper',
        outer    : 'outer-wrapper',
        container: 'off-canvas-menu'
        open     : 'menu-open'
      },
      transEndEventNames: {
        'WebkitTransition' : 'webkitTransitionEnd',
        'MozTransition'    : 'transitionend',
        'OTransition'      : 'oTransitionEnd otransitionend',
        'msTransition'     : 'MSTransitionEnd',
        'transition'       : 'transitionend'
      }
    });

#### Options you may wish to change

* `direction`: (string) Direction from which the menu enters the containing element. Valid values are `left` or `right`. Default `left`.
* `coverage`: (string) Width (in CSS units) of the menu when it is open/active. Relative units are relative to the `container` element. In all but the most experimental cases this is the `body` element, which means this effectively translates to coverage of the visible viewport. `px` or other non-percentage units are OK, but you must include the unit. Default is `70%`. We haven't tested with much variation to that!
* `trigger`: jQuery selector for the element that should trigger the show/hide of the menu. Default `#menu-trigger`.
* `menu`: jQuery selector for the menu element itself. Default `#menu`.

#### Other options

For the most part, you'll want to leave these alone; they're there in case you run into namespace conflicts in CSS or other deeper issues.

* `duration`: The time the animation should take to complete in milliseconds.
* `container`: Nominally it should be possible to use a different container element other than the `body` element that is the default. But we haven't tried it!
* `classes` : The class names that get assigned to different elements needed to make the menu work. You can change these if you have a conflict or other burning desire for change.
* `transEndEventNames`: When CSS transitions are used we attach some events to the `transitionend` callback, which can differ in name browser-to-browser. We use a method similar to [Modernizr](http://modernizr.com/docs/#prefixed) and [Twitter Bootstrap](https://github.com/twitter/bootstrap/blob/master/js/bootstrap-transition.js) for determining the event name, referencing the keys in this list.

### 5. Functions

* `on()`: You'll usually run this function right after initializing the menu. It causes the menu to be moved off-canvas and enables toggle(), show(), and hide().
* `off()`: This function causes the menu to move to its original position and disables toggle(), show(), and hide().
* `toggle()`: Toggles the menu.
* `show()`: Shows the menu.
* `hide()`: Hides the menu.

## Known Issues

### Android animation bugs

Some versions of the Android browser handle percentage transforms [rather strangely](http://css-tricks.com/forums/discussion/20269/transform-translate-percentages-and-android/p1). Specifying a non-percentage value for `coverage` should alleviate the issue.

