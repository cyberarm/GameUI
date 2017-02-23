class Container
  GOOD_COLOR = Gosu::Color.rgb(0, 100, 0)
  BAD_COLOR  = Gosu::Color.rgb(100, 0, 0)

  attr_accessor :text_color
  attr_reader :elements, :x, :y, :width, :height, :options
  attr_reader :scroll_x, :scroll_y, :internal_width, :internal_height

  def initialize(x = 0, y = 100, width = $window.width, height = $window.height, options = {})
    @x, @y, @width, @height, @internal_width, @internal_height = x, y, width, height-y, width, height-y
    @scroll_x, @scroll_y = 0, 0
    @scroll_speed = 10
    puts "#{self.class}: with #{width}, height #{@height}"

    @options = {}
    @text_color = Text::COLOR
    @elements = []

    if defined?(self.setup); setup; end
  end

  def draw
    Gosu.clip_to(x, y, width, height) do
      Gosu.translate(scroll_x, scroll_y) do
        @elements.each(&:draw)
      end
    end
  end

  def update
    @elements.each(&:update)
  end

  def button_up(id)
    if $window.mouse.x.between?(@x, @x+@width)
      if $window.mouse.y.between?(@y, @y+@height)
        case id
        when Gosu::MsWheelUp
          @scroll_y+=@scroll_speed
          @scroll_y = 0 if @scroll_y > 0
          @elements.each {|e| e.set_offset(@scroll_x, @scroll_y) if e.is_a?(Button) }
        when Gosu::MsWheelDown
          @scroll_y-=@scroll_speed
          if $window.height-@internal_height-y > 0
            @scroll_y = 0
            p "H: #{@height-@internal_height}", "Y: #{@scroll_y}"
          else
            @scroll_y = @height-@internal_height if @scroll_y <= @height-@internal_height
          end

          @elements.each {|e| e.set_offset(@scroll_x, @scroll_y) if e.is_a?(Button) }
        end
      end
    end

    @elements.each {|e| if defined?(e.button_up); e.button_up(id); end}
  end

  def build(&block)
    yield(self)
  end

  def text(text, x, y, size = Text::SIZE, color = self.text_color)
    relative_x = @x+x
    relative_y = @y+y
    _text      = Text.new(text, false, x: relative_x, y: relative_y, size: size, color: color)
    @elements.push(_text)
    if _text.y-(_text.height*2) > @internal_height
      @internal_height+=_text.height
    end

    return _text
  end

  def button(text, x, y, &block)
    relative_x = @x+x
    relative_y = @y+y
    _button    = Button.new(text, relative_x, relative_y, false) { if block.is_a?(Proc); block.call; end }
    @elements.push(_button)
    if _button.y-(_button.height*2) > @internal_height
      @internal_height+=_button.height
    end

    return _button
  end

  def fill_rect(x, y, width, height, color = BODY_COLOR, z = 0)
    $window.fill_rect(x, y, width, height, color)
  end

  def fill(color = BODY_COLOR, z = 0)
    fill_rect(@x, @y, @width, @height, color, z)
  end

  def set_layout_y(start, spacing)
    @layout_y_start = start
    @layout_y_spacing = spacing
    @layout_y_count = 0
  end

  def layout_y(stay = false)
    i = @layout_y_start+(@layout_y_spacing*@layout_y_count)
    @layout_y_count+=1 unless stay
    return i
  end

  def calc_percentage(positive, total)
    begin
      i = ((positive.to_f/total.to_f)*100.0).round(2)
      if !i.nan?
        return "#{i}%"
      else
        "N/A"
      end
    rescue ZeroDivisionError => e
      puts e
      return "N/A" # 0 / 0, safe to assume no actionable data
    end
  end

  def switch_team(button_id, container, mode= :scouting)
    appsync_method = nil
    case mode
    when :scouting
      appsync_method = :team_has_scouting_data?
    when :match
      appsync_method = :team_has_match_data?
    else
      raise
    end

    case button_id
    when Gosu::KbRight
      current_team = AppSync.team_number
      AppSync.teams_list.detect do |number, name|
        next unless AppSync.send(appsync_method, number)
        if number > current_team
          AppSync.active_team(number)
          $window.active_container = container.new
          true
        end
      end

      if AppSync.team_number == current_team # && AppSync.send(appsync_method, AppSync.teams_list.first.first)
        AppSync.active_team(AppSync.teams_list.first.first)
        $window.active_container = container.new
      end

    when Gosu::KbLeft
      current_team = AppSync.team_number
      teams = []
      AppSync.teams_list.each do |number, name|
        next unless AppSync.send(appsync_method, number)
        if number < current_team
          teams.push(number)
        end
      end

      if teams.last
        AppSync.active_team(teams.last)
        $window.active_container = container.new
      end

      if AppSync.team_number == current_team # && AppSync.send(appsync_method, AppSync.teams_list.to_a.last.first)
        AppSync.active_team(AppSync.teams_list.to_a.last.first)
        $window.active_container = container.new
      end
    end
  end
end
