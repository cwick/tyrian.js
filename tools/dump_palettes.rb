require 'json'

PALETTE_COUNT = 23

open("../data/palette.dat", "rb") do |f|
  palette_count = f.size / (256*3)
  palettes = []

  raise "Bad palette count" unless palette_count == PALETTE_COUNT

  palette_count.times do
    palette = []

    256.times do
      color = {}
      color[:r] = f.getbyte << 2
      color[:g] = f.getbyte << 2
      color[:b] = f.getbyte << 2

      palette << color
    end

    palettes << palette
  end

  File.open("../assets/palettes.json", "w") { |f| f.write JSON.pretty_generate(palettes) }
end



