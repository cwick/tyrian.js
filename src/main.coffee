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

    loader = new Two.AssetLoader(baseDir: "converted_data")
    loader.preloadImage "player_ships.png"

    ship = @scene.add new Two.TransformNode(position: [40 - 24, 160 - 7])
    shipSprite = new Two.Sprite(anchorPoint: [0,1], image: loader.loadImage("player_ships"), crop: { x: 210, y: 32, width: 24, height: 27 })
    ship.add new Two.RenderNode(elements: [shipSprite])

game = new Game()
game.start()

