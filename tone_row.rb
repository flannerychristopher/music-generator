# frozen_string_literal: true

require './line'

# behavior specific to a tone row
class ToneRow < Line
  def compose_next_pitch(previous_pitches, pitches)
    available_pitches = pitches - previous_pitches
    available_pitches.sample
  end
end