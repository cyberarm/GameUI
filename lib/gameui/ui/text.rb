class Text
  SIZE = 20
  FONT = Gosu.default_font_name
  COLOR= Gosu::Color::WHITE

  CACHE = {}

  attr_accessor :text, :x, :y, :z, :size, :factor_x, :factor_y, :color, :options
  attr_reader :textobject

  def initialize(text, auto_manage = true, options={})
    @text = text || ""
    @options = options
    @size = options[:size] || SIZE
    @font = options[:font] || FONT
    @x = options[:x] || 0
    @y = options[:y] || 0
    @z = options[:z] || 1025
    @factor_x = options[:factor_x] || 1
    @factor_y = options[:factor_y] || 1
    @color    = options[:color] || COLOR
    @textobject = check_cache(@size, @font)

    Window.instance.elements.push(self) if auto_manage

    return self
  end

  def check_cache(size, font_name)
    available = false
    font      = nil

    if CACHE[size]
      if CACHE[size][font_name]
        font = CACHE[size][font_name]
        available = true
      else
        available = false
      end
    else
      available = false
    end

    unless available
      font = Gosu::Font.new(@size, name: @font)
      CACHE[@size] = {}
      CACHE[@size][@font] = font
    end

    return font
  end

  def width
    textobject.text_width(@text)
  end

  def height
    textobject.height
  end

  def draw
    @textobject.draw(@text, @x, @y, @z, @factor_x, @factor_y, @color)
  end

  def update; end
end
