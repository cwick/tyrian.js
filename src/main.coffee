`module Two from "two"`

Game = Two.Game.extend
  configure: ->
    scale = 2
    @canvas.width = 320 * scale
    @canvas.height = 200 * scale
    @camera.width = 320
    @camera.height = 200
    @renderer.backend.imageSmoothingEnabled = false

    loader = new Two.AssetLoader(baseDir: "converted_data")
    loader.preloadImage "player_ships.png"

    ship = @scene.add new Two.TransformNode(position: [20, 200])
    shipSprite = new Two.Sprite(anchorPoint: [0,1], image: loader.loadImage("player_ships"), crop: { x: 2, y: 2, width: 24, height: 28 })
    ship.add new Two.RenderNode(elements: [shipSprite])

game = new Game()
game.start()

