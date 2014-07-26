`module Two from "two"`

Weapon = Two.GameObject.extend
  initialize: ->
    @weaponsData = @game.loader.loadObject("weapons")

  spawn: (options) ->
    @canFireShot = true
    @weapon = @weaponsData[options.weaponNumber]

  fireShots: ->
    @_fireShot() if @canFireShot

  _fireShot: ->
    @_spawnShot(x) for x in [0..@weapon.multi-1]
    @canFireShot = false

    @game.setTimeout @weapon.shotrepeat / @game.tyrian.TICKS_PER_SECOND, =>
      @canFireShot = true

  _spawnShot: (shotNumber) ->
    spawnX = @weapon.bx[shotNumber]
    spawnY = @weapon.by[shotNumber]

    velocityX = @weapon.sx[shotNumber] * @game.tyrian.TICKS_PER_SECOND
    velocityY = -@weapon.sy[shotNumber] * @game.tyrian.TICKS_PER_SECOND

    shot = @game.spawn "Shot", spriteNumber: @weapon.sg[shotNumber]
    shot.physics.position = [@transform.parent.position.x + 1 + spawnX, @transform.parent.position.y + spawnY]
    shot.physics.velocity = [velocityX, velocityY]

`export default Weapon`
