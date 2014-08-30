`module Two from "two"`

Background = Two.GameObject.extend
  spawn: ->
    sprites = @game.loader.loadSpritesheet "shapes/shapesz"
    level = @game.loader.loadJSON "levels/ep1/9"
    console.log level

    for rowNumber in [283..299]
      for columnNumber, tileNumber of level.map1[rowNumber]
        tile = sprites.clone()
        tile.frame = level.shapes[0][tileNumber] - 1
        tileTransform = new Two.TransformNode(position: [columnNumber*24, (rowNumber-283)*28])
        tileTransform.add new Two.RenderNode(elements: [tile])
        @game.tyrian.layers.background1.add tileTransform

  update: ->
    player = @game.world.findByName "Player"
    tempW = Math.floor((260 - (player.transform.position.x - 36)) / (260 - 36) * (24 * 3) - 1)
    tempW = (tempW * 2) / 3
    tempW = tempW / 2
    tempW = Math.floor(tempW)

    # @game.tyrian.layers.background1.position.x = 24*1
    # @game.tyrian.layers.background1.position.x = -player.transform.position.x + 24*4
    @game.tyrian.layers.background1.position.x = tempW - 24*2

    # -1 to 2
`export default Background`
