# frozen_string_literal: true

require './line'

# behavior specific to a Melody Line
class Melody < Line
  def compose_next_pitch(previous_pitches, pitches)
    # intialize with a random pitch
    return pitches.sample if previous_pitches.empty?

    # 2/9 chance we pick sample a random pitch
    return pitches.sample unless (-1..7).to_a.sample.positive?

    # otherwise pick a neighboring pitch
    previous_pitch_index = pitches.index(previous_pitches.last)
    next_pitch_index = previous_pitch_index + [-1, 1].sample
    pitches[next_pitch_index] || pitches.first
  end
end
