# frozen_string_literal: true

# require './chord'

# Build a Tonality
class Tonality
  attr_accessor :scale

  def initialize(scale = [0, 2, 4, 7, 9])
    @scale = format_scale(scale)
  end

  def pitches
    map_octaves(@scale)
  end

  def root_pitches
    map_octaves([@scale.first])
  end

  def melody_pitches
    range = (12..20).to_a.sample
    pitches[24..(24 + range)]
  end

  def bass_pitches
    range = (12..16).to_a.sample
    pitches[12..(12 + range)]
  end

  # def chords
  #   @scale.reduce([]) do |pitch|
  #     Chord.new(root: pitch, pitches: tonality.pitches)
  #   end
  # end

  private

  def map_octaves(scale)
    result = []
    root_pitch = scale.first
    root_pitch.step(127, 12) do |octave_pitch|
      new_octave = scale.map { |pitch| pitch + octave_pitch }
      result += new_octave
    end
    result
  end

  def format_scale(scale)
    formatted_scale = scale.each_with_object([]) do |pitch, memo|
      low_pitch = pitch % 12
      memo << low_pitch unless memo.include?(low_pitch)
      memo
    end
    formatted_scale.sort
  end
end
