# frozen_string_literal: true

require './line'

# behavior specific to a Bass Line
class Bass < Line
  def compose_next_pitch(previous_pitches, pitches)
    return (pitches.first + 24) if previous_pitches.empty?

    return pitches.sample unless (-1..4).to_a.sample.positive?

    previous_pitch_index = pitches.index(previous_pitches.last)
    next_pitch_index = previous_pitch_index + [-1, 1].sample
    pitches[next_pitch_index] || pitches.first
  end
end
