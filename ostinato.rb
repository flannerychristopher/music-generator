# frozen_string_literal: true

# behavior specific to an Ostina Line
class Ostinato < Line
  def compose_next_pitch(_previous_pitches, pitches)
    # return a pitch 6 octaves higher than the lowest pitch
    pitches.first + (12 * 6)
  end
end
