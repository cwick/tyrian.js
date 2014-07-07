`module Two from "two"`

Shot = Two.GameObject.extend Two.Components.ArcadePhysics,
  initialize: ->
    @shotData = @game.loader.loadObject("weapons")[155]
    shotSpriteNumber = @shotData.sg[0]
    shotSpriteFrame = @game.loader.loadObject("player_shots").frames[shotSpriteNumber].frame

    shotSprite = new Two.Sprite
      anchorPoint: [0,1]
      image: @game.loader.loadImage("player_shots")
      crop:
        x: shotSpriteFrame.x
        y: shotSpriteFrame.y
        width: shotSpriteFrame.w
        height: shotSpriteFrame.h

    @transform.add new Two.RenderNode(elements: [shotSprite])

  spawn: ->
    @game.tyrian.layers.shots.add @transform
    @physics.velocity = [0, -@shotData.sy[0] * @game.tyrian.TICKS_PER_SECOND]

`export default Shot`
