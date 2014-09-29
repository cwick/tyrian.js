`module Two from "two"`

DebugOverlay = Two.Object.extend
  initialize: ->
    FONT_SIZE = 6

    @_fpsText = new Two.Text(fontSize: FONT_SIZE)
    @_objectCountText = @_fpsText.clone()
    @_renderTimeText = @_fpsText.clone()
    @_physicsTimeText = @_fpsText.clone()
    @_logicTimeText = @_fpsText.clone()

    @sceneNode = new Two.TransformNode()
    @_addText(@_objectCountText, [0, 10])
    @_addText(@_fpsText, [0, 0])
    @_addText(@_renderTimeText, [0, 200])

    @sceneNode.add(new Two.RenderNode(elements: [label])) for label in [
      @_physicsTimeText, @_logicTimeText]

  logicTime: Two.Property
    set: (value) -> @_logicTimeText.text = "Logic: #{value}ms"

  renderTime: Two.Property
    set: (value) -> @_renderTimeText.text = "Render: #{value}ms"

  fps: Two.Property
    set: (value) -> @_fpsText.text = "FPS: #{value}"

  objectCount: Two.Property
    set: (value) -> @_objectCountText.text = "Game objects: #{value}"

  _addText: (text, position) ->
    @sceneNode.add(new Two.TransformNode(position: position)).add new Two.RenderNode(elements: [text])


`export default DebugOverlay`
