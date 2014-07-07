`module Two from "two"`
`import Player from "./player"`
`import Shot from "./shot"`

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

    # TODO: game viewport needs to be shifted over by 24 pixels to match what Tyrian does
    # @scene.position.x -= 24

    @loader.baseDir = "converted_data"
    @tyrian =
      TICKS_PER_SECOND: 35

MainState = Two.State.extend
  initialize: ->
    @fpsSampler = new Two.PeriodicSampler(3)

  preload: ->
    @game.loader.preloadImage "player_ships.png"
    @game.loader.preloadObject "player_ships.json"

    @game.loader.preloadImage "player_shots.png"
    @game.loader.preloadObject "player_shots.json"

    @game.loader.preloadImage "pics/2.png"
    @game.loader.preloadObject "weapons.json"

  enter: ->
    background = @game.scene.add new Two.TransformNode()
    backgroundSprite = new Two.Sprite(anchorPoint: [0,1], image: @game.loader.loadImage("pics/2"))
    background.add new Two.RenderNode(elements: [backgroundSprite])

    @game.spawn "Player"
    @fpsText = new Two.Text(fontSize: 6)
    @game.scene.add(new Two.RenderNode(elements: [@fpsText]))

  step: (increment) ->
    @fpsText.text = "FPS: #{@fpsSampler.sample(@game.debug.fps)}"

game = new Game()
game.registerEntity "Player", Player
game.registerEntity "Shot", Shot
game.registerState "main", MainState

game.start("main")

