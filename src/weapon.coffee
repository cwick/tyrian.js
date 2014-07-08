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
    @_spawnShot(0)
    @canFireShot = false

    @game.setTimeout @weapon.shotrepeat / @game.tyrian.TICKS_PER_SECOND, =>
      @canFireShot = true

  _spawnShot: (shotNumber) ->
    shot = @game.spawn "Shot", spriteNumber: @weapon.sg[shotNumber]
    shot.physics.position = [@transform.parent.position.x + 1, @transform.parent.position.y]
    shot.physics.velocity = [0, -@weapon.sy[shotNumber] * @game.tyrian.TICKS_PER_SECOND]

`export default Weapon`
