# frozen_string_literal: true

require 'midilib/sequence'
require 'byebug'

require './rhythm'
require './tonality'

# behavior common to all compositions
class Composition
  include MIDI

  def initialize
    # A MIDI::Sequence contains MIDI::Track objects.
    @seq = Sequence.new
  end

  private

  def create_track
    track = Track.new(@seq)
    @seq.tracks << track
    track
  end

  def compose_line(line:, pitches:, velocities:, rhythm:)
    rhythm.events.each do |duration|
      pitch = line.compose_next_pitch(line.events.map(&:note), pitches)
      velocity = velocities.sample
      line.events << NoteOn.new(0, pitch, velocity, 0)
      line.events << NoteOff.new(0, pitch, velocity, duration)
    end
  end

  def write_midi_file
    file_name = "midi/#{Time.now}.mid"
    File.open(file_name, 'wb') { |file| @seq.write(file) }
  end
end
