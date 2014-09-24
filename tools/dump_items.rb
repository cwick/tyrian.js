require 'json'
require_relative "file_lib"

WEAP_NUM = 780
PORT_NUM = 42

open("../data/tyrian.hdt", "rb") do |f|
  f.seek(efread(JE_longint, 1, f).first)
  f.read(2*7)

  weapons = {}
  weapon_ports = {}

  (0..WEAP_NUM).each do |i|
    weapon = {}
    weapon[:drain] =           efread(JE_word, 1, f).first
    weapon[:shotrepeat] =      efread(JE_byte, 1, f).first
    weapon[:multi] =           efread(JE_byte, 1, f).first
    weapon[:weapani] =         efread(JE_word, 1, f).first
    weapon[:max] =             efread(JE_byte, 1, f).first
    weapon[:tx] =              efread(JE_byte, 1, f).first
    weapon[:ty] =              efread(JE_byte, 1, f).first
    weapon[:aim] =             efread(JE_byte, 1, f).first
    weapon[:attack] =          efread(JE_byte, 8, f)
    weapon[:del] =             efread(JE_byte, 8, f)
    weapon[:sx] =              efread(JE_shortint, 8, f)
    weapon[:sy] =              efread(JE_shortint, 8, f)
    weapon[:bx] =              efread(JE_shortint, 8, f)
    weapon[:by] =              efread(JE_shortint, 8, f)
    weapon[:sg] =              efread(JE_word, 8, f)
    weapon[:acceleration] =    efread(JE_shortint, 1, f).first
    weapon[:accelerationx] =   efread(JE_shortint, 1, f).first
    weapon[:circlesize] =      efread(JE_byte, 1, f).first
    weapon[:sound] =           efread(JE_byte, 1, f).first
    weapon[:trail] =           efread(JE_byte, 1, f).first
    weapon[:shipblastfilter] = efread(JE_byte, 1, f).first

    weapons[i] = weapon
  end

  (0..PORT_NUM).each do |i|
    weapon_port = {}

    f.seek(1, IO::SEEK_CUR) # skip string length

    weapon_port[:name] = f.read(30).strip
    weapon_port[:opnum] = efread(JE_byte, 1, f).first
    weapon_port[:op] = []

    2.times do
      weapon_port[:op] << efread(JE_word, 11, f)
    end

    weapon_port[:cost] = efread(JE_word, 1, f).first
    weapon_port[:itemgraphic] = efread(JE_word, 1, f).first
    weapon_port[:poweruse] = efread(JE_word, 1, f).first

    weapon_ports[i] = weapon_port
  end

  File.open("../assets/weapons.json", "w") { |f| f.write JSON.pretty_generate(weapons) }
  File.open("../assets/weapon_ports.json", "w") { |f| f.write JSON.pretty_generate(weapon_ports) }
end

