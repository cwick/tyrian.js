require 'json'

def load_palettes
  JSON.parse File.open("../out/palettes.json").read
end

def indexed_to_truecolor(indexed_data, palette_index=0)
  truecolor = []
  palettes = load_palettes
  palette = palettes[palette_index]

  indexed_data.each do |i|
    color = palette[i]

    if i == -1
      truecolor += [0,0,0,0]
    else
      truecolor += [color["r"]*257, color["g"]*257, color["b"]*257, 255*257]
    end
  end

  truecolor
end


