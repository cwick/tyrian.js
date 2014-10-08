`module Two from "two"`

WeaponComponent = Two.Components.Base.extend
  initialize: ->
    console.log "weapon component"

`export default WeaponComponent`

