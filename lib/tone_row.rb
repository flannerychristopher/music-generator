# frozen_string_literal: true

require './line'

# behavior specific to a tone row
class ToneRow < Line
  def compose_next_pitch(previous_pitches, pitches)
    return pitches.first if previous_pitches.empty?

    last_pitch_index = pitches.index(previous_pitches.last)
    pitches[last_pitch_index + 1] || pitches.first
  end
end