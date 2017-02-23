BUTTON_TEXT_COLOR        = Gosu::Color::WHITE
BUTTON_TEXT_ACTIVE_COLOR = Gosu::Color::BLACK
BUTTON_COLOR             = Gosu::Color.rgb(12,12,12)
BUTTON_HOVER_COLOR       = Gosu::Color.rgb(100, 100, 100)
BUTTON_ACTIVE_COLOR      = Gosu::Color.rgb(50, 50, 50)
BUTTON_TEXT_SIZE         = 20
BUTTON_PADDING           = 10

class Button
  attr_reader :text, :x, :y, :offset_x, :offset_y, :block

  def initialize(text, x, y, auto_manage = true, &block)
    @text = Text.new(text, false, x: x, y: y, size: BUTTON_TEXT_SIZE, color: BUTTON_TEXT_COLOR)
    @x = x
    @y = y
    @offset_x, @offset_y = 0, 0
    if block
      @block = Proc.new{yield(self)}
    else
      @block = Proc.new {}
    end

    Window.instance.elements.push(self) if auto_manage

    return self
  end

  def draw
    @text.draw

    $window.fill_rect(@x, @y, width, height, BUTTON_COLOR)

    if mouse_clicked_on_check
      $window.fill_rect(@x+1, @y+1, width-2, height-2, BUTTON_ACTIVE_COLOR)
    elsif mouse_over?
      $window.fill_rect(@x+1, @y+1, width-2, height-2, BUTTON_HOVER_COLOR)
    else
      $window.fill_rect(@x+1, @y+1, width-2, height-2, BUTTON_COLOR)
    end

  end

  def update
    @text.x = @x+BUTTON_PADDING
    @text.y = @y+BUTTON_PADDING
  end

  def button_up(id)
    case id
    when Gosu::MsLeft
      click_check
    end
  end

  def click_check
    if mouse_over?
      puts "Clicked: #{@text.text}"
      @block.call if @block.is_a?(Proc)
    end
  end

  def mouse_clicked_on_check
    if mouse_over? && Gosu.button_down?(Gosu::MsLeft)
      true
    end
  end

  def mouse_over?
    if $window.mouse.x.between?(@x+@offset_x, @x+@offset_x+width)
      if $window.mouse.y.between?(@y+@offset_y, @y+@offset_y+height)
        true
      end
    end
  end

  def width
    @text.textobject.text_width(@text.text)+BUTTON_PADDING*2
  end

  def height
    @text.textobject.height+BUTTON_PADDING*2
  end

  def set_offset(x, y)
    @offset_x, @offset_y = x, y
  end

  def update_text(string)
    @text.text = string
  end
end
