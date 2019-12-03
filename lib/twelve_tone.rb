# frozen_string_literal: true

require './composition'
require './tone_row'

# create a 12 tone composition
class TwelveTone < Composition
  def initialize
    super
    @track = create_track
    twelve_tone_scale = (0..11).to_a
    @tonality = Tonality.new(twelve_tone_scale)
    @tone_row = ToneRow.new
  end

  def perform
    velocities = [70]

    # pick 12 of them and shuffle them
    pitches = @tonality.pitches[50..61].shuffle

    durations = [480]
    rhythm_length = 480 * pitches.length
    # rhythm.events holds an array of durations
    rhythm = Rhythm.new(length: rhythm_length, durations: durations)

    compose_line(line: @tone_row,
                 pitches: pitches,
                 velocities: velocities,
                 rhythm: rhythm)

    # write the line events to the track
    @track.events += @tone_row.events

    write_midi_file
  end
end

TwelveTone.new.perform
