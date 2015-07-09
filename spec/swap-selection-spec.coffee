SwapSelection = require '../lib/swap-selection'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "SwapSelection", ->
  [activationPromise, editor, editorView] = []

  swapSelection = (callback) ->
    atom.commands.dispatch editorView, 'swap-selection:right'
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open()

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorView = atom.views.getView(editor)
      activationPromise = atom.packages.activatePackage('swap-selection')

  describe "swap selections", ->
    describe "when there is multiple selections", ->
      it "swaps the selection", ->
        editor.setText 'two one three'

        # selecting "one" "two"
        editor.setSelectedBufferRanges([[[0, 0], [0, 3]], [[0, 4], [0, 7]]])

        swapSelection ->
          expect(editor.getText()).toBe 'one two three'
