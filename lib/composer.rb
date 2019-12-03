# frozen_string_literal: true

require 'midilib/sequence'

class Composer
  include MIDI

  def compose_line(line:, pitches:, velocities:, rhythm:)
    rhythm.events.each do |duration|
      previous_pitches = line.events.map(&:note)
      pitch = next_pitch(previous_pitches, pitches)

      velocity = velocities.sample

      line.events << NoteOn.new(0, pitch, velocity, 0)
      line.events << NoteOff.new(0, pitch, velocity, duration)
    end
  end

  def next_pitch(previous_pitches, pitches)
    return pitches.sample if previous_pitches.empty?

    return pitches.sample unless (-1..7).to_a.sample.positive?

    previous_pitch_index = pitches.index(previous_pitches.last)
    next_pitch_index = previous_pitch_index + [-1, 1].sample
    pitches[next_pitch_index] || pitches.first
  end
end