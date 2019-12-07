# frozen_string_literal: true

# require './chord'

# Build a Tonality
class Tonality
  attr_accessor :scale

  def initialize(scale = [0, 2, 4, 7, 9])
    @scale = format_scale(scale)
  end

  def pitches
    result = []
    lowest_pitch = @scale.first
    lowest_pitch.step(127, 12) do |octave_of_lowest_pitch|
      new_octave = map_octave(octave_of_lowest_pitch)
      result += new_octave
    end
    result
  end

  def root_pitches
    map_octave(@scale.first)
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

  # def map_octaves scale
  #   result = []
  #   root_pitch = scale.first
  #   root_pitch.step(127, 12) do |octave_pitch|
  #     new_octave = scale.map { |pitch| pitch + octave_pitch }
  #     result += new_octave
  #   end
  #   result
  # end


  def map_octave octave_of_root_pitch
    @scale.filter_map do |pitch|
      octave_of_pitch = (octave_of_root_pitch + pitch)
      octave_of_pitch unless octave_of_pitch > 127
    end
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
