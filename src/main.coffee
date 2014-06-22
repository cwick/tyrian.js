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

    @world.physics.arcade.collideWorldBounds = false

    @loader.baseDir = "converted_data"

    @loader.preloadImage "player_ships.png"
    @loader.preloadImage "pics/2.png"


    background = @scene.add new Two.TransformNode()
    background.add new Two.RenderNode(elements: [new Two.Sprite(anchorPoint: [0,1], image: @loader.loadImage("pics/2"))])

    @spawn "Player"

game = new Game()

game.registerEntity "Player", Two.GameObject.extend Two.Components.ArcadePhysics,
  initialize: ->
    tyrianOrigin = @transform.add new Two.TransformNode(position: [-24 - 5, -7])
    shipSprite = new Two.Sprite
      anchorPoint: [0,1]
      image: @game.loader.loadImage("player_ships")
      crop: { x: 210, y: 32, width: 24, height: 27 }

    tyrianOrigin.add new Two.RenderNode(elements: [shipSprite])

    @physics.boundingBox.fromSprite shipSprite
    @physics.boundingBox.y *= -1
    @physics.postUpdate = => @constrainToScreenBounds()

  spawn: ->
    @physics.position = [40, 10]

  update: ->
    @physics.velocity.x = 0
    @physics.velocity.y = 0

    if @game.input.keyboard.isKeyDown Two.Keys.LEFT
      @physics.velocity.x += -1
    if @game.input.keyboard.isKeyDown Two.Keys.RIGHT
      @physics.velocity.x += 1

    if @game.input.keyboard.isKeyDown Two.Keys.UP
      @physics.velocity.y += -1
    if @game.input.keyboard.isKeyDown Two.Keys.DOWN
      @physics.velocity.y += 1

    @physics.velocity.x *= 4 * 60
    @physics.velocity.y *= 4 * 60

  constrainToScreenBounds: ->
    if @physics.position.x < 40
      @physics.position.x = 40

    if @physics.position.x > 256
      @physics.position.x = 256

    if @physics.position.y < 10
      @physics.position.y = 10

    if @physics.position.y > 160
      @physics.position.y = 160

game.start()

