def read_encrypted_pascal_string(f)
  len = f.getbyte
  if len != nil
    s = f.read len
    decrypt_pascal_string(s)
  end
end

def decrypt_pascal_string(s)
  crypt_key = [ 204, 129, 63, 255, 71, 19, 25, 62, 1, 99 ];
  bytes = s.bytes

  (bytes.length-1).downto(0).each do |i|
    bytes[i] ^= crypt_key[i % crypt_key.length]
    bytes[i] ^= bytes[i-1] if i > 0
  end

  bytes.pack("c*")
end

def parse_section(s, file)
  raise "Bad line" unless s[0] == "]"

  commands = []

  while s != ""
    code = s[1]
    parsing_func = $parsing_functions[code]
    raise "Unknown code '#{code}'" unless parsing_func

    parsed_command = parsing_func.call(s, file)
    commands << parsed_command if parsed_command
    s = read_encrypted_pascal_string(file)
  end

  $sections << commands
end

def parse_section_jump(s, file)
  {
    command: "section_jump",
    section: s[3..5].to_i
  }
end

def parse_cubes(s, file)
  {
    command: "cubes",
    cubes: s[7..-1].split(" ").map { |x| x.to_i }
  }
end

def parse_cube_max(s, file)
  {
    command: "cube_max",
    value: s[4..-1].to_i
  }
end

def parse_maps(s, file)
  {
    command: "unused"
  }
end

def parse_items_available(s, file)
  9.times { read_encrypted_pascal_string(file) }

  {
    command: "unused"
  }
end

def parse_nothing(s, file)
  nil
end

def parse_level(s, file)
  {
    command: "level",
    next_level: s[9..11].to_i,
    level_name: s[13..21].strip,
    level_song: s[22..23].to_i,
    level_file_num: s[25..27].to_i
  }
end

$parsing_functions = {
  "J" => method(:parse_section_jump),
  "?" => method(:parse_cubes),
  "!" => method(:parse_cube_max),
  "G" => method(:parse_maps),
  "I" => method(:parse_items_available),
  "h" => method(:parse_nothing),
  "H" => method(:parse_nothing),
  "L" => method(:parse_level),
}

$sections = []

open("../data/levels1.dat", "rb") do |f|
  begin
    while s = read_encrypted_pascal_string(f)
      next if s[0] == "*" || s == ""
      parse_section(s, f)
    end
  rescue => e
    puts e.inspect
  end

  $sections.each_with_index do |section, i|
    puts i+1
    puts section
    puts
  end
end

