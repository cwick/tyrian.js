JE_longint = [4, "l"]
JE_integer = [2, "s"]
JE_shortint = [1, "c"]
JE_word = [2, "S"]
JE_byte = [1, "C"]

def efread(type, count, f)
  f.read(type[0]*count).unpack("#{type[1]}#{count}")
end


