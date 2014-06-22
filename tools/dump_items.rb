WEAP_NUM = 780

JE_longint = [4, "l"]
JE_integer = [2, "2"]
JE_shortint = [1, "c"]
JE_word = [2, "S"]
JE_byte = [1, "C"]

def efread(type, count, f)
  f.read(type[0]*count).unpack("#{type[1]}#{count}")
end

open("../data/tyrian.hdt", "rb") do |f|
  f.seek(efread(JE_longint, 1, f).first)
  f.read(2*7)

  weapons = []

  WEAP_NUM.times do
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

    weapons << weapon

    puts "drain=#{weapon[:drain]}, shotrepeat=#{weapon[:shotrepeat]}"
  end
end
