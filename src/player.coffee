`module Two from "two"`

Player = Two.GameObject.extend Two.Components.ArcadePhysics,
  initialize: ->
    tyrianOrigin = @transform.add new Two.TransformNode(position: [-24 - 5, -7])

    @shipSprite = @loadShip 233

    tyrianOrigin.add new Two.RenderNode(elements: [@shipSprite])

    @physics.boundingBox.fromSprite @shipSprite
    @physics.boundingBox.y *= -1
    @physics.postUpdate = => @constrainToScreenBounds()
    @physics.maxVelocity = [@maxVelocity, @maxVelocity]
    @physics.drag = [@acceleration/2, @acceleration/2]

  maxVelocity: Two.Property
    get: -> 4 * @game.tyrian.TICKS_PER_SECOND

  acceleration: Two.Property
    get: -> Math.pow @game.tyrian.TICKS_PER_SECOND, 2

  spawn: ->
    @physics.position = [100, 180]

  update: ->
    @updateMovement()
    @updateBankAngle()

  updateMovement: ->
    @physics.acceleration.x = 0
    @physics.acceleration.y = 0

    if @game.input.keyboard.isKeyDown Two.Keys.LEFT
      @physics.acceleration.x -= 1
    if @game.input.keyboard.isKeyDown Two.Keys.RIGHT
      @physics.acceleration.x += 1

    if @game.input.keyboard.isKeyDown Two.Keys.UP
      @physics.acceleration.y -= 1
    if @game.input.keyboard.isKeyDown Two.Keys.DOWN
      @physics.acceleration.y += 1

    @physics.acceleration.x *= @acceleration
    @physics.acceleration.y *= @acceleration

  updateBankAngle: ->
    bankAmount = @physics.velocity.x / @game.tyrian.TICKS_PER_SECOND
    bankFrame = Math.floor((bankAmount)/2)

    @shipSprite.frame = bankFrame

  constrainToScreenBounds: ->
    if @physics.position.x < 40
      @physics.position.x = 40

    if @physics.position.x > 256
      @physics.position.x = 256

    if @physics.position.y < 10
      @physics.position.y = 10
      @physics.velocity.y = 0

    if @physics.position.y > 160
      @physics.position.y = 160
      @physics.velocity.y = 0

  loadShip: (num) ->
    ships = @game.loader.loadObject("player_ships").frames
    frames = {}

    # Set up sprites for ship banking angles
    frames[0] = ships[num].frame
    frames[1] = ships[num+2].frame
    frames[-1] = ships[num-2].frame
    frames[2] = ships[num+4].frame
    frames[-2] = ships[num-4].frame

    shipSprite = new Two.Sprite
      anchorPoint: [0,1]
      image: @game.loader.loadImage("player_ships")

    for name, frame of frames
      shipSprite.addFrame name,
        x: frame.x
        y: frame.y
        width: frame.w
        height: frame.h

    shipSprite.frame = 0
    shipSprite

`export default Player`
