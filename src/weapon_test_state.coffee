`import BaseState from "./base_state"`
`module $ from "jquery"`

WeaponTestState = BaseState.extend
  enter: ->
    BaseState.prototype.enter.apply @

`export default WeaponTestState`


