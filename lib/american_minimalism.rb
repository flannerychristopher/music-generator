require './composition'
require './composer'
require './line'
require './line/bass'
require './line/melody'
require './line/ostinato'

# create a composition in the style of american minimalism
class AmericanMinimalism < Composition
  def initialize
    super

    # Create tracks to hold the notes. Add it to the sequence.
    @melody_track = create_track
    @bass_track = create_track
    @ostinato_track = create_track

    @composer = Composer.new
    @tonality = Tonality.new
    @melody = Line.new
    @bass = Line.new
    @ostinato = Ostinato.new
  end

  def perform
    melody_velocities = (50..75).to_a + [0, 0, 0, 0]
    @composer.compose_line(line: @melody,
                 pitches: @tonality.melody_pitches,
                 velocities: melody_velocities,
                 rhythm: Rhythm.new(length: 3840))

    bass_rhythm = Rhythm.new(durations: [960, 480])
    @composer.compose_line(line: @bass,
                 pitches: @tonality.bass_pitches,
                 velocities: (50..70).to_a,
                 rhythm: bass_rhythm)

    @composer.compose_line(line: @ostinato,
                 pitches: @tonality.root_pitches,
                 velocities: (50..65).to_a,
                 rhythm: Rhythm.new(length: 1920))

    write_lines_to_tracks
    write_midi_file
  end

  private

  def write_lines_to_tracks
    16.times { @ostinato_track.events += @ostinato.events }

    @melody_track.events << NoteOff.new(0, 0, 0, 3840) # rest 8 beats
    7.times { @melody_track.events += @melody.events }

    @bass_track.events << NoteOff.new(0, 0, 0, 7680) # rest 16 beats
    3.times { @bass_track.events += @bass.events }
  end
end

AmericanMinimalism.new.perform
