#tab的切换
(($)->
  class TwinsEditor
    constructor: (@container)->
      @init()
      @initSimditor()

    initSimditor: ()->

      options =
        textarea: @elements.panel.find("[data-field='simditor'] textarea")
        pasteImage: true

      @simditor = new Simditor options

    init: ()->
      activeClass = 'active'
      $o = @container
      els = @elements =
        menu: $o.find('ul.nav')
        panel: $o.find('div.panel')

      els.menu.find('>li').bind 'click', ()->
        $this = $(this)
        field = $this.attr 'data-field'

        #切换active
        els.menu.find('>li.active').removeClass activeClass
        $this.addClass(activeClass)

        els.panel.children().hide()
        els.panel.find("[data-field='#{field}']").show()

      els.menu.find('>li.active').click()


  $.fn.twinsEditor = (options)->
    storeKey = 'tab_instance'
    instance = this.data storeKey
    return instance if instance

    instance = new TwinsEditor(this, options)
    this.data storeKey, instance
)(jQuery)