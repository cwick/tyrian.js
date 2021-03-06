`module Two from "two"`

Player = Two.GameObject.extend
  initialize: ->
    @addComponent Two.Components.Transform
    @addComponent Two.Components.ArcadePhysics
    tyrianOrigin = @transform.add new Two.TransformNode(position: new Two.Vector2d([-5, -7]))

    @shipSprite = @loadShip 233

    tyrianOrigin.add new Two.RenderNode(renderable: @shipSprite)

    @physics.boundingBox = @shipSprite.boundingBox
    @physics.delegate = @
    @physics.maxVelocity.setValues [@maxVelocity, @maxVelocity]
    @physics.drag.setValues [@acceleration/2, @acceleration/2]

  maxVelocity: Two.Property
    get: -> 4 * @game.tyrian.TICKS_PER_SECOND

  acceleration: Two.Property
    get: -> Math.pow @game.tyrian.TICKS_PER_SECOND, 2

  prepareToSpawn: ->
    @physics.position.setValues [110, 160]
    @game.tyrian.layers.ships.add @transform
    @weapon = @game.spawn "Weapon", weaponNumber: 155, attachTo: @

  tick: ->
    @updateMovement()
    @updateBankAngle()
    @fireShots()

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

  fireShots: ->
    @weapon.fireShots() if @game.input.keyboard.isKeyDown(Two.Keys.SPACEBAR)

  switchWeapon: (weaponNumber) ->
    @weapon.prepareToSpawn weaponNumber: weaponNumber

  physicsBodyDidUpdate: ->
    @constrainShipToScreenBounds()

  constrainShipToScreenBounds: ->
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
    ships = @game.loader.loadJSON("player_ships").frames
    frames = {}

    # Set up sprites for ship banking angles
    frames[0] = ships[num].frame
    frames[1] = ships[num+2].frame
    frames[-1] = ships[num-2].frame
    frames[2] = ships[num+4].frame
    frames[-2] = ships[num-4].frame

    shipSprite = new Two.Sprite
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
