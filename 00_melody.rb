# frozen_string_literal: true

require 'midilib/sequence'
require 'midilib/consts'

# create a twelve tone melody
class Melody
  include MIDI

  def initialize
    # A MIDI::Sequence contains MIDI::Track objects.
    @seq = Sequence.new

    # Create a track to hold the notes. Add it to the sequence.
    @track = Track.new(@seq)
    @seq.tracks << @track
  end

  private

  def write_note_sequence_to_track note_sequence
    note_sequence.each do |note|
      velocity = note_velocities.sample
      length = note_lengths.sample

      # initialize(channel = 0, note = 64, velocity = 64, delta_time = 0)
      @track.events << NoteOn.new(0, note, velocity, 0)
      @track.events << NoteOff.new(0, note, velocity, length)
    end
  end

  def write_midi_file
    file_name = "midi/#{Time.now}.mid"
    File.open(file_name, 'wb') { |file| @seq.write(file) }
  end

  def note_lengths
    [480]
  end

  def note_velocities
    [64]
  end
end
