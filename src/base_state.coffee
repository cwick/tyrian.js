`module Two from "two"`
`import DebugOverlay from "./debug_overlay"`
`import Player from "./player"`
`import Shot from "./shot"`
`import Weapon from "./weapon"`
`import Background from "./background"`

BaseState = Two.State.extend
  preload: ->
    @game.loader.preloadSpritesheet "player_ships"
    @game.loader.preloadSpritesheet "player_shots"
    @game.loader.preloadSpritesheet "shapes/shapesz"

    @game.loader.preloadImage "pics/2.png"
    @game.loader.preloadJSON "weapons.json"
    @game.loader.preloadJSON "weapon_ports.json"
    @game.loader.preloadJSON "levels/ep1/9.json"

  enter: ->
    @registerEntities()
    @game.scene.removeAll()

    @setupScene()

    @game.spawn "Player", name: "Player"
    @game.spawn "Background"

  tick: (deltaSeconds) ->
    @updateDebugOverlay()

    if @game.input.keyboard.wasKeyPressed(Two.Keys.D)
      @debugOverlay.sceneNode.enabled = !@debugOverlay.sceneNode.enabled

  beforeRender: ->
    @viewportRenderer.render(@game.tyrian.viewport, @viewportCamera)

  setupScene: ->
    @viewportCamera = new Two.Camera(width: 264, height: 184)
    @viewportRenderer = @createViewportRenderer()

    @game.scene.add @createGameUI()
    @game.scene.add @createViewportCanvas(@viewportCamera, @viewportRenderer)

    @game.tyrian.viewport.add @game.tyrian.layers.background1
    @game.tyrian.viewport.add @game.tyrian.layers.shots
    @game.tyrian.viewport.add @game.tyrian.layers.ships

    @debugOverlay = new DebugOverlay()
    @debugOverlay.sceneNode.enabled = false
    @game.scene.add(@debugOverlay.sceneNode)

  createGameUI: ->
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
    @debugOverlay.fps = @game.debug.fps
    @debugOverlay.objectCount = @game.world.entityCount
    @debugOverlay.frameTime = @game.debug.frameTime.total
    @debugOverlay.renderTime = @game.debug.frameTime.render
    @debugOverlay.logicTime = @game.debug.frameTime.logic
    @debugOverlay.physicsTime = @game.debug.frameTime.physics
    @debugOverlay.drawImageCalls = @game.debug.callCounter.drawImage
    @debugOverlay.playerPosition = @game.world.findByName("Player").transform.position

  registerEntities: ->
    @game.registerEntity "Player", Player
    @game.registerEntity "Shot", Shot
    @game.registerEntity "Weapon", Weapon
    @game.registerEntity "Background", Background

`export default BaseState`
