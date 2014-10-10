`module Two from "two"`

DebugOverlay = Two.Object.extend
  initialize: ->
    FONT_SIZE = 6

    @_sampler = new Two.PeriodicSampler(4)
    @_fpsText = new Two.Text(fontSize: FONT_SIZE)
    @_frameTimeText = @_fpsText.clone()
    @_objectCountText = @_fpsText.clone()
    @_renderTimeText = @_fpsText.clone()
    @_physicsTimeText = @_fpsText.clone()
    @_logicTimeText = @_fpsText.clone()
    @_drawImageText = @_fpsText.clone()
    @_renderCommandsText = @_fpsText.clone()
    @_playerPositionText = @_fpsText.clone()

    @sceneNode = new Two.TransformNode()
    @_addText(@_objectCountText, [0, 155])
    @_addText(@_fpsText, [0, 0])
    @_addText(@_frameTimeText, [0, 10])
    @_addText(@_renderTimeText, [6, 20])
    @_addText(@_logicTimeText, [6, 30])
    @_addText(@_physicsTimeText, [6, 40])
    @_addText(@_drawImageText, [0, 175])
    @_addText(@_renderCommandsText, [0, 165])
    @_addText(@_playerPositionText, [150, 190])

  frameTime: Two.Property
    set: (value) ->
      TERRIBLE_PERFORMANCE_THRESHOLD = 1/30*1000
      POOR_PERFORMANCE_THRESHOLD = 1/60*1000

      value = @_sampler.sample(value, "frame")
      @_frameTimeText.text = "Frame: #{value}ms"

      if value > TERRIBLE_PERFORMANCE_THRESHOLD
        @_frameTimeText.color = "red"
      else if value > POOR_PERFORMANCE_THRESHOLD
        @_frameTimeText.color = "yellow"
      else
        @_frameTimeText.color = "white"

  logicTime: Two.Property
    set: (value) -> @_logicTimeText.text = "Logic: #{@_sampler.sample(value, "logic")}ms"

  renderTime: Two.Property
    set: (value) -> @_renderTimeText.text = "Render: #{@_sampler.sample(value, "render")}ms"

  physicsTime: Two.Property
    set: (value) -> @_physicsTimeText.text = "Physics: #{@_sampler.sample(value, "physics")}ms"

  fps: Two.Property
    set: (value) -> @_fpsText.text = "FPS: #{@_sampler.sample(value, "fps")}"

  objectCount: Two.Property
    set: (value) -> @_objectCountText.text = "Game objects: #{@_sampler.sample(value, "objects")}"

  drawImageCalls: Two.Property
    set: (value) -> @_drawImageText.text = "drawImage calls: #{@_sampler.sample(value, "drawImage")}"

  renderCommands: Two.Property
    set: (value) -> @_renderCommandsText.text = "Render commands: #{@_sampler.sample(value, "renderCommands")}"

  playerPosition: Two.Property
    set: (value) -> @_playerPositionText.text = "Player X: #{value.x.toFixed(2)} Y: #{value.y.toFixed(2)}"

  _addText: (text, position) ->
    @sceneNode.add(
      new Two.TransformNode(position: new Two.Vector2d(position))
    ).add new Two.RenderNode(renderable: text)

`export default DebugOverlay`
