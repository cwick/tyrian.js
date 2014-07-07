`module Two from "two"`

Shot = Two.GameObject.extend Two.Components.ArcadePhysics,
  initialize: ->
    weapon = @game.loader.loadObject("weapons")[155]
    shotSpriteNumber = weapon.sg[0]
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

`export default Shot`
