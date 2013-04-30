class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

$titles = [ 'Nivalis!', 'Frenata!', 'Putorius!', 'Ermina!', 'Nigripes!' ]
$rounds = 20
$round = 0

require 'ruboto/activity'
require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :Button, :LinearLayout, :TextView, :EditText

class LeperActivity
  def onCreate(bundle)
    super
    set_title $titles[rand($titles.count)]

    self.content_view =
      linear_layout :orientation => :vertical do
        linear_layout :orientation => :horizontal do
          text_view :text => 'Round: ', :text_size => 24
          @round = text_view :text => '', :text_size => 24
        end
        linear_layout :orientation => :horizontal do
          text_view :text => 'X: ', :text_size => 24
          @x_view = text_view :text => '', :text_size => 24
        end
        linear_layout :orientation => :horizontal do
          text_view :text => 'Y: ', :text_size => 24
          @y_view = text_view :text => '', :text_size => 24
        end
        text_view :text => '-----------', :text_size => 24
        linear_layout :orientation => :horizontal do
          @ans = edit_text :width => 200
          button :text => 'Oouh!', :on_click_listener => proc { next_problem }
        end
      end
  rescue
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  private

  def new_problem
    x, y = rand(100), rand(100)
    [ x.to_s, y.to_s, x + y ]
  end

  def next_problem
    @ans.setText ''
    if $round == $rounds
      toast 'Finis.'
    else
      @round.setText(($round + 1).to_s)
      problem = new_problem
      @x_view.setText problem[0]
      @y_view.setText problem[1]
      $round += 1
    end
  end

end

$irb.start_ruboto_activity :class_name => "LeperActivity"
