require './composition'
require './bass'
require './melody'
require './ostinato'

# create a composition in the style of american minimalism
class AmericanMinimalism < Composition
  def initialize
    super

    # Create tracks to hold the notes. Add it to the sequence.
    @melody_track = create_track
    @bass_track = create_track
    @ostinato_track = create_track

    @tonality = Tonality.new
    @melody = Melody.new
    @bass = Bass.new
    @ostinato = Ostinato.new
  end

  def perform
    melody_velocities = (50..75).to_a + [0, 0, 0, 0]
    compose_line(line: @melody,
                 pitches: @tonality.melody_pitches,
                 velocities: melody_velocities,
                 rhythm: Rhythm.new)

    bass_rhythm = Rhythm.new(durations: [960, 480])
    compose_line(line: @bass,
                 pitches: @tonality.bass_pitches,
                 velocities: (50..70).to_a,
                 rhythm: bass_rhythm)

    compose_line(line: @ostinato,
                 pitches: @tonality.bass_pitches[0..0],
                 velocities: (50..65).to_a,
                 rhythm: Rhythm.new)

    write_lines_to_tracks
    write_midi_file
  end

  private

  def permute_note_events(events, pitches)
    indexes = (0..events.length).reject(&:odd?).to_a.shuffle.take(4)

    indexes.each do |index|
      new_pitch = pitches.sample
      events[index].note = new_pitch     # NoteOn
      events[index + 1].note = new_pitch # NoteOff
    end
    events
  end

  def write_lines_to_tracks
    6.times { @ostinato_track.events += @ostinato.events }

    @melody_track.events << NoteOff.new(0, 0, 0, 7680)
    5.times { @melody_track.events += @melody.events }

    @bass_track.events << NoteOff.new(0, 0, 0, 15_340)
    4.times { @bass_track.events += @bass.events }
  end
end

AmericanMinimalism.new.perform
