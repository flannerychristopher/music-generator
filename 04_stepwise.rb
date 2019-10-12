# frozen_string_literal: true

require './00_melody'

# create a tonal melody with stepwise motion
class Stepwise < Melody
  def perform
    note_sequence = [64, 66, 68, 69, 71, 73, 75]

    write_note_sequence_to_track(note_sequence)
    write_midi_file
  end
end

Stepwise.new.perform
