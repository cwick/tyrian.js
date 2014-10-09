`module Two from "two"`

Weapon = Two.GameObject.extend
  initialize: ->
    @weaponsData = @game.loader.loadJSON("weapons")

  spawn: (options) ->
    @owner = options.attachTo || @owner
    throw new Error("Weapons must be attached to a game object") unless @owner?

    @canFireShot = true
    @weapon = @weaponsData[options.weaponNumber]
    @nextShot = 0

  fireShots: ->
    @_fireShot() if @canFireShot

  _fireShot: ->
    shotsFired = 0
    while shotsFired < @weapon.multi
      @_spawnShot(@nextShot)
      shotsFired++
      @nextShot++
      @nextShot = 0 if @nextShot == @weapon.max || @nextShot > 7

    @canFireShot = false

    @game.setTimeout @weapon.shotrepeat / @game.tyrian.TICKS_PER_SECOND, =>
      @canFireShot = true

  _spawnShot: (shotNumber) ->
    spawnX = @weapon.bx[shotNumber]
    spawnY = @weapon.by[shotNumber]

    velocityX = @weapon.sx[shotNumber] * @game.tyrian.TICKS_PER_SECOND
    velocityY = -@weapon.sy[shotNumber] * @game.tyrian.TICKS_PER_SECOND

    accelerationX = @weapon.accelerationx * Math.pow @game.tyrian.TICKS_PER_SECOND, 2
    accelerationY = -@weapon.acceleration * Math.pow @game.tyrian.TICKS_PER_SECOND, 2

    shot = @game.spawn "Shot", spriteNumber: @weapon.sg[shotNumber]

    if @weapon.sx[shotNumber] == 101 || @weapon.sx[shotNumber] == 120
      velocityX = 0
      shot.slave = @owner
      shot.matchPosition = true

    if @weapon.sx[shotNumber] == 101
      shot.matchVelocity = true

    shot.physics.position = [@owner.transform.position.x + 1 + spawnX,
      @owner.transform.position.y + spawnY]
    shot.physics.velocity = [velocityX, velocityY]
    shot.initialVelocity = [velocityX, velocityY]
    shot.physics.acceleration = [accelerationX, accelerationY]

`export default Weapon`
