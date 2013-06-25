class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

$rounds = 20
$round = 0
$correct = 0

$titles = [ 'Nivalis!', 'Frenata!', 'Putorius!', 'Ermina!', 'Nigripes!' ]
require 'ruboto/activity'
require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :Button, :LinearLayout, :TextView, :EditText

class ArithmeticActivity
  def onCreate(bundle)
    super
    set_title $titles[rand($titles.count)]

    self.content_view =
      linear_layout :orientation => :vertical do
        linear_layout :orientation => :horizontal do
          text_view :text => 'Round: ', :text_size => 24
          @round = text_view :text => '1', :text_size => 24
        end
        linear_layout :orientation => :horizontal do
          text_view :text => 'Correct: ', :text_size => 24
          @correct_v = text_view :text => '0', :text_size => 24
        end
        linear_layout :orientation => :horizontal do
          text_view :text => 'Incorrect: ', :text_size => 24
          @incorrect_v = text_view :text => '0', :text_size => 24
        end
        linear_layout :orientation => :horizontal do
          text_view :text => 'X: ', :text_size => 24
          @x_view = text_view :text => '75', :text_size => 24
        end
        linear_layout :orientation => :horizontal do
          text_view :text => 'Y: ', :text_size => 24
          @y_view = text_view :text => '12', :text_size => 24
        end
        text_view :text => '-----------', :text_size => 24
        linear_layout :orientation => :horizontal do
          @ans = edit_text :width => 200
          button :text => 'Oouh!', :on_click_listener => proc { grade }
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
    if $round > $rounds
      toast 'Finis.'
    else
      $round += 1
      @round.setText($round.to_s)
      @np = new_problem
      @x_view.setText @np[0]
      @y_view.setText @np[1]
      $round += 1
    end
  end

  def grade
    if @ans.getText.to_i == @np[2]
      $correct += 1
    end
    @correct_v.setText $correct.to_s
    @incorrect_v.setText ($round - $correct).to_s
    next_problem
  end

end

# $irb.start_ruboto_activity :class_name => "ArithmeticActivity"
