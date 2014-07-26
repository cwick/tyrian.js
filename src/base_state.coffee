`module Two from "two"`

BaseState = Two.State.extend
  initialize: ->
    @debugSampler = new Two.PeriodicSampler(3)

  preload: ->
    @game.loader.preloadImage "player_ships.png"
    @game.loader.preloadObject "player_ships.json"

    @game.loader.preloadImage "player_shots.png"
    @game.loader.preloadObject "player_shots.json"

    @game.loader.preloadImage "pics/2.png"
    @game.loader.preloadObject "weapons.json"
    @game.loader.preloadObject "weapon_ports.json"

  enter: ->
    @game.scene.removeAll()

    background = @game.scene.add new Two.TransformNode()
    backgroundSprite = new Two.Sprite(anchorPoint: [0,1], image: @game.loader.loadImage("pics/2"))
    background.add new Two.RenderNode(elements: [backgroundSprite])

    @game.scene.add @game.tyrian.viewport
    @game.tyrian.viewport.add @game.tyrian.layers.shots
    @game.tyrian.viewport.add @game.tyrian.layers.ships

    @game.spawn "Player", name: "Player"
    @fpsText = new Two.Text(fontSize: 6)
    @objectCountText = new Two.Text(fontSize: 6)
    @game.scene.add(new Two.RenderNode(elements: [@fpsText]))
    @game.scene.add(new Two.TransformNode(position: [0, 10])).add new Two.RenderNode(elements: [@objectCountText])

  step: (increment) ->
    @fpsText.text = "FPS: #{@debugSampler.sample(@game.debug.fps, "fps")}"
    @objectCountText.text = "Game objects: #{@debugSampler.sample(@game.world.entityCount, "objects")}"

`export default BaseState`
