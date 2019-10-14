# frozen_string_literal: true

# Build a Tonality
class Tonality
  attr_accessor :pitches

  def initialize(scale = [0, 2, 4, 7, 9])
    @pitches = []

    12.step(108, 12) do |octave_pitch|
      new_octave = scale.map { |pitch| pitch + octave_pitch }
      @pitches += new_octave
    end
  end

  def melody_pitches
    range = (12..20).to_a.sample
    @pitches[24..(24 + range)]
  end

  def bass_pitches
    range = (12..16).to_a.sample
    @pitches[0..range]
  end
end
