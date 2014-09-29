`import BaseState from "./base_state"`
`module $ from "jquery"`

WeaponTestState = BaseState.extend
  switchWeapon: ->
    weapon = @weaponPorts[$("#weapon-select").val()]
    power = $("#power-select").val()

    @game.world.findByName("Player").switchWeapon weapon.op[0][power]

  enter: ->
    BaseState.prototype.enter.apply @

    weaponSelect = $("#weapon-selector")
    weaponSelect.html("""
      <h1>Weapon Select</h1>
      <select id="weapon-select"> </select>
      <select id="power-select"> </select>
      <br>
      <h2>Instructions</h2>
      <table>
        <tr>
          <td>Arrow Keys</td>
          <td>Move ship</td>
        </tr>
        <tr>
          <td>Spacebar</td>
          <td>Fire weapon</td>
        </tr>
        <tr>
          <td>D</td>
          <td>Toggle debug overlay</td>
        </tr>
      </table>
    """)

    @weaponPorts = @game.loader.loadJSON("weapon_ports")
    @weaponPorts = (@weaponPorts[k] for k of @weaponPorts).sort((a,b) ->
      return 1 if a.name > b.name
      return -1 if a.name < b.name
      return 0
    )

    for weapon,i in @weaponPorts
      $("#weapon-select").append($("<option>", value: i, html: weapon.name))

    for i in [1..11]
      $("#power-select").append($("<option>", value: i-1, html: i))

    $("#weapon-select").on "change", (e) =>
      $("#weapon-select").blur()
      $("#power-select").val(0)
      @switchWeapon()

    $("#power-select").on "change", (e) =>
      $("#power-select").blur()
      @switchWeapon()

`export default WeaponTestState`


