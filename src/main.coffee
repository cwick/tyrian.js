`module Two from "two"`
`import Player from "./player"`

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

class MainState
  preload: (game) ->
    game.loader.preloadImage "player_ships.png"
    game.loader.preloadImage "pics/2.png"

  enter: (game) ->
    background = game.scene.add new Two.TransformNode()
    backgroundSprite = new Two.Sprite(anchorPoint: [0,1], image: game.loader.loadImage("pics/2"))
    background.add new Two.RenderNode(elements: [backgroundSprite])

    game.spawn "Player"

game = new Game()
game.registerEntity "Player", Player
game.registerState "main", MainState

game.start("main")

