`module Two from "two"`

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

    @fpsText = new Two.Text(fontSize: 6)
    @objectCountText = new Two.Text(fontSize: 6)
    @game.scene.add(new Two.RenderNode(elements: [@fpsText]))
    @game.scene.add(new Two.TransformNode(position: [0, 10])).add new Two.RenderNode(elements: [@objectCountText])

  step: (increment) ->
    @fpsText.text = "FPS: #{@debugSampler.sample(@game.debug.fps, "fps")}"
    @objectCountText.text = "Game objects: #{@debugSampler.sample(@game.world.entityCount, "objects")}"

  beforeRender: ->
    @viewportRenderer.render(@game.tyrian.viewport, @viewportCamera)

  setupScene: ->
    @viewportCamera = new Two.Camera(width: 264, height: 184)
    @viewportRenderer = @createViewportRenderer()

    @game.scene.add @createChrome()
    @game.scene.add @createViewportCanvas()

    @game.tyrian.viewport.add @game.tyrian.layers.background1
    @game.tyrian.viewport.add @game.tyrian.layers.shots
    @game.tyrian.viewport.add @game.tyrian.layers.ships

  createChrome: ->
    chrome = new Two.TransformNode()
    chromeSprite = new Two.Sprite(image: @game.loader.loadImage("pics/2"))
    chrome.add new Two.RenderNode(elements: [chromeSprite])

  createViewportRenderer: ->
    renderer = new Two.SceneRenderer(backgroundColor: "black")
    renderer.backend.flipYAxis = true
    renderer

  createViewportCanvas: ->
    canvas = @viewportRenderer.backend.canvas
    canvas.width = @viewportCamera.width
    canvas.height = @viewportCamera.height

    viewportSprite = new Two.Sprite
      width: canvas.width
      height: canvas.height
      image: canvas.domElement

    transform = new Two.TransformNode()
    transform.add new Two.RenderNode(elements: [viewportSprite])

    transform

`export default BaseState`
