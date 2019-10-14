# frozen_string_literal: true

# behavior specific to an Ostina Line
class Ostinato < Line
  def compose_next_pitch(_previous_pitches, pitches)
    pitches.first + (12 * 7)
  end
end
