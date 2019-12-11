# frozen_string_literal: true

# require './chord'

class Tonality
  attr_accessor :scale

  def initialize(scale = [0, 2, 4, 7, 9])
    @scale = format_scale(scale)
  end

  def pitches
    map_scale_over_octaves(@scale)
  end

  def octave_pitches pitch
    formatted_scale = format_scale([pitch])
    map_scale_over_octaves(formatted_scale)
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

  def map_scale_over_octaves scale
    result = []
    0.step(127, 12) do |octave_root_pitch|
      new_octave = map_pitches_over_octave(scale, octave_root_pitch)
      result += new_octave
    end
    result
  end

  def map_pitches_over_octave pitches, octave_root_pitch
    pitches.filter_map do |pitch|
      octave_of_pitch = (octave_root_pitch + pitch)
      octave_of_pitch if octave_of_pitch.between?(0, 127)
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
