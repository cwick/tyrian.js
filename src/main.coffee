`module Two from "two"`
`import Player from "./player"`
`import Shot from "./shot"`
`import Weapon from "./weapon"`

Game = Two.Game.extend
  initialize: ->
    scale = 2
    @canvas.width = 320 * scale
    @canvas.height = 200 * scale
    @camera.width = 320
    @camera.height = 200
    @renderer.backend.imageSmoothingEnabled = false
    @renderer.backend.flipYAxis = true

    @world.physics.arcade.collideWorldBounds = false

    @loader.baseDir = "converted_data"
    @tyrian =
      TICKS_PER_SECOND: 35
      viewport: new Two.TransformNode(position: [-24, 0])
      layers:
        shots: new Two.TransformNode()
        ships: new Two.TransformNode()

MainState = Two.State.extend
  initialize: ->
    @fpsSampler = new Two.PeriodicSampler(3)
    @objectSampler = new Two.PeriodicSampler(4)

  preload: ->
    @game.loader.preloadImage "player_ships.png"
    @game.loader.preloadObject "player_ships.json"

    @game.loader.preloadImage "player_shots.png"
    @game.loader.preloadObject "player_shots.json"

    @game.loader.preloadImage "pics/2.png"
    @game.loader.preloadObject "weapons.json"

  enter: ->
    @game.scene.removeAll()

    background = @game.scene.add new Two.TransformNode()
    backgroundSprite = new Two.Sprite(anchorPoint: [0,1], image: @game.loader.loadImage("pics/2"))
    background.add new Two.RenderNode(elements: [backgroundSprite])

    @game.scene.add @game.tyrian.viewport
    @game.tyrian.viewport.add @game.tyrian.layers.shots
    @game.tyrian.viewport.add @game.tyrian.layers.ships

    @game.spawn "Player"
    @fpsText = new Two.Text(fontSize: 6)
    @objectCountText = new Two.Text(fontSize: 6)
    @game.scene.add(new Two.RenderNode(elements: [@fpsText]))
    @game.scene.add(new Two.TransformNode(position: [0, 10])).add new Two.RenderNode(elements: [@objectCountText])

  step: (increment) ->
    @fpsText.text = "FPS: #{@fpsSampler.sample(@game.debug.fps)}"
    @objectCountText.text = "Game objects: #{@objectSampler.sample(@game.world.objects.length)}"

game = new Game()
game.registerEntity "Player", Player
game.registerEntity "Shot", Shot
game.registerEntity "Weapon", Weapon
game.registerState "main", MainState

game.start("main")

