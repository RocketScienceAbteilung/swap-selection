{CompositeDisposable} = require 'atom'

module.exports = SwapSelection =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-text-editor',
      'swap-selection:cycle': => @cycle(),
      'swap-selection:left': => @cycle(false),
      'swap-selection:right': => @cycle(true)

  deactivate: ->
    @subscriptions.dispose()

  cycle: (right) ->
    if editor = atom.workspace.getActiveTextEditor()
      texts = editor.getSelections().map (item) -> item.getText()

      if right
        texts.unshift(texts.pop())
      else
        texts.push(texts.shift())

      for selection, i in editor.getSelections()
        selection.insertText(texts[i], {select: true})
