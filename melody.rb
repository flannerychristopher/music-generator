# frozen_string_literal: true

require './line'

# behavior specific to a Melody Line
class Melody < Line
  def compose_next_pitch(previous_pitches, pitches)
    return pitches.sample if previous_pitches.empty?

    return pitches.sample unless (-1..7).to_a.sample.positive?

    previous_pitch_index = pitches.index(previous_pitches.last)
    next_pitch_index = previous_pitch_index + [-1, 1].sample
    pitches[next_pitch_index] || pitches.first
  end
end
