`module Two from "two"`

Game = Two.Game.extend
  configure: ->
    scale = 2
    @canvas.width = 320 * scale
    @canvas.height = 200 * scale
    @camera.width = 320
    @camera.height = 200
    @renderer.backend.imageSmoothingEnabled = false
    @renderer.backend.flipYAxis = false

    @loader.baseDir = "converted_data"

    @loader.preloadImage "player_ships.png"
    @loader.preloadImage "pics/2.png"

    background = @scene.add new Two.TransformNode()
    background.add new Two.RenderNode(elements: [new Two.Sprite(anchorPoint: [0,1], image: @loader.loadImage("pics/2"))])

    @spawn "Player"

game = new Game()

game.registerEntity "Player", Two.GameObject.extend
  initialize: ->
    tyrianOrigin = @transform.add new Two.TransformNode(position: [-24 - 5, -7])
    shipSprite = new Two.Sprite
      anchorPoint: [0,1]
      image: @game.loader.loadImage("player_ships")
      crop: { x: 210, y: 32, width: 24, height: 27 }

    tyrianOrigin.add new Two.RenderNode(elements: [shipSprite])

  spawn: ->
    @transform.position = [40, 10]

game.start()

