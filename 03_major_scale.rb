# frozen_string_literal: true

require './00_melody'

# create a tonal melody
class MajorScale < Melody
  def perform
    note_sequence = [64, 66, 68, 69, 71, 73, 75]

    write_note_sequence_to_track(note_sequence)
    write_midi_file
  end

  private

  def note_lengths
    [720, 480, 240, 120, 60]
  end
end

MajorScale.new.perform
