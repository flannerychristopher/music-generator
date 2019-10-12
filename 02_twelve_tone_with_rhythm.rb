# frozen_string_literal: true

require './00_melody'

# create a twelve tone melody
class TwelveToneWithRythm < Melody
  def perform
    note_sequence = (64..74).to_a.shuffle

    write_note_sequence_to_track(note_sequence)
    write_midi_file
  end

  private

  def note_lengths
    [480, 240, 120, 60]
  end
end

TwelveToneWithRythm.new.perform
