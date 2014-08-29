require_relative "file_lib"
require 'json'
require 'fileutils'
require 'RMagick'

SHAPES_DIR = "../converted_data/temp/shapes"

def load_level_offsets(f)
  level_offsets = []
  level_count = efread(JE_word, 1, f).first
  level_count.times do
    level_offsets << efread(JE_longint, 1, f).first
  end

  level_offsets
end

def dump_tiles(level)
  (0..2).each do |layer|
    full_image = Magick::ImageList.new

    level[:"map#{layer+1}"].each do |row_data|
      row = Magick::ImageList.new
      row_data.map do |tile| level[:shapes][layer][tile] end.each do |tile|
        row.push(Magick::Image.read(SHAPES_DIR + level[:shape_file] + "/shape_#{tile-1}.png").first)
      end
      full_image.push(row.append(false))
    end

    FileUtils.mkdir_p "../converted_data/temp/levels/#{level[:index]}"
    full_image.append(true).write("PNG32:../converted_data/temp/levels/#{level[:index]}/#{layer}.png")
  end

end

def dump_level(f, index, offset)
  level = {}

  level[:index] = index
  level[:file_offset] = offset

  f.seek level[:file_offset]

  f.getbyte # char_mapFile
  level[:shape_file] = [f.getbyte].pack('c*').downcase
  level[:map_x] = efread(JE_word, 1, f).first
  level[:map_x2] = efread(JE_word, 1, f).first
  level[:map_x3] = efread(JE_word, 1, f).first
  level[:enemies] = []
  level[:events] = []

  efread(JE_word, 1, f).first.times do
    level[:enemies] << efread(JE_word, 1, f).first
  end

  efread(JE_word, 1, f).first.times do
    event = {}
    event[:event_time] = efread(JE_word, 1, f).first
    event[:event_type] = efread(JE_byte, 1, f).first
    event[:event_dat] = efread(JE_integer, 1, f).first
    event[:event_dat2] = efread(JE_integer, 1, f).first
    event[:event_dat3] = efread(JE_shortint, 1, f).first
    event[:event_dat5] = efread(JE_shortint, 1, f).first
    event[:event_dat6] = efread(JE_shortint, 1, f).first
    event[:event_dat4] = efread(JE_byte, 1, f).first
    level[:events] << event
  end

  # Swap byte order of shapes
  level[:shapes] = efread(JE_word, 3*128, f).map do |x| [x].pack("n").unpack("S").first end.each_slice(128).to_a
  level[:map1] = efread(JE_byte, 300*14, f).each_slice(14).to_a
  level[:map2] = efread(JE_byte, 600*14, f).each_slice(14).to_a
  level[:map3] = efread(JE_byte, 600*15, f).each_slice(15).to_a

  # dump_tiles(level)
  FileUtils.mkdir_p "../converted_data/levels/ep1"
  File.write "../converted_data/levels/ep1/#{level[:index]}.json", JSON.pretty_generate(level)
end

open("../data/tyrian1.lvl", "rb") do |f|
  level_offsets = load_level_offsets(f)
  (1..level_offsets.length/2).each do |i|
    dump_level(f, i, level_offsets[(i-1)*2])
  end
end

