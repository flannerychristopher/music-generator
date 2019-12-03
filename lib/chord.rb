# frozen_string_literal: true

class Chord
  def initialize pitch: 0, pitches: [0, 2, 4, 7, 9]
    @root_pitch = pitch % 12
    @pitches = pitches
  end
end
