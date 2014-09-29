`module Two from "two"`
`import DebugOverlay from "./debug_overlay"`

BaseState = Two.State.extend
  initialize: ->
    @debugSampler = new Two.PeriodicSampler(3)

  preload: ->
    @game.loader.preloadSpritesheet "player_ships"
    @game.loader.preloadSpritesheet "player_shots"
    @game.loader.preloadSpritesheet "shapes/shapesz"

    @game.loader.preloadImage "pics/2.png"
    @game.loader.preloadJSON "weapons.json"
    @game.loader.preloadJSON "weapon_ports.json"
    @game.loader.preloadJSON "levels/ep1/9.json"

  enter: ->
    @game.scene.removeAll()

    @setupScene()

    @game.spawn "Player", name: "Player"
    @game.spawn "Background"

  tick: (deltaSeconds) ->
    @updateDebugOverlay()

  beforeRender: ->
    @viewportRenderer.render(@game.tyrian.viewport, @viewportCamera)

  setupScene: ->
    @viewportCamera = new Two.Camera(width: 264, height: 184)
    @viewportRenderer = @createViewportRenderer()

    @game.scene.add @createChrome()
    @game.scene.add @createViewportCanvas(@viewportCamera, @viewportRenderer)

    @game.tyrian.viewport.add @game.tyrian.layers.background1
    @game.tyrian.viewport.add @game.tyrian.layers.shots
    @game.tyrian.viewport.add @game.tyrian.layers.ships

    @debugOverlay = new DebugOverlay()
    @game.scene.add(@debugOverlay.sceneNode)

  createChrome: ->
    chrome = new Two.TransformNode()
    chromeSprite = new Two.Sprite(image: @game.loader.loadImage("pics/2"))
    chrome.add new Two.RenderNode(elements: [chromeSprite])

  createViewportRenderer: ->
    renderer = new Two.SceneRenderer(backgroundColor: "black")
    renderer.backend.flipYAxis = true
    renderer

  createViewportCanvas: (camera, renderer) ->
    canvas = renderer.backend.canvas
    canvas.width = camera.width
    canvas.height = camera.height

    viewportSprite = new Two.Sprite
      width: canvas.width
      height: canvas.height
      image: canvas.domElement

    transform = new Two.TransformNode()
    transform.add new Two.RenderNode(elements: [viewportSprite])

    transform

  updateDebugOverlay: ->
    @debugOverlay.fps = @debugSampler.sample(@game.debug.fps, "fps")
    @debugOverlay.objectCount = @debugSampler.sample(@game.world.entityCount, "objects")
    @debugOverlay.frameTime = @game.debug.frameTime.total
    @debugOverlay.renderTime = @game.debug.frameTime.render
    @debugOverlay.logicTime = @game.debug.frameTime.logic
    @debugOverlay.physicsTime = @game.debug.frameTime.physics

`export default BaseState`
