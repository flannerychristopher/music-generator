require 'byebug'
require 'midilib/sequence'
require 'midilib/consts'

require './bass'
require './melody'
require './ostinato'
require './rhythm'
require './tonality'

class AmericanMinimalism
  include MIDI

  def initialize
    # A MIDI::Sequence contains MIDI::Track objects.
    @seq = Sequence.new

    tempo = Tempo.bpm_to_mpq(120)

    # Create two tracks to hold the notes. Add it to the sequence.
    @track0 = Track.new(@seq)
    @seq.tracks << @track0
    @track0.name = 'melody'
    @track0.events << Tempo.new(tempo)

    @track1 = Track.new(@seq)
    @seq.tracks << @track1
    @track1.name = 'bass'

    @track2 = Track.new(@seq)
    @seq.tracks << @track2
    @track1.name = 'ostinato'

    # set the tonality aka scale
    @tonality = Tonality.new
    @melody = Melody.new
    @bass = Bass.new
    @ostinato = Ostinato.new
  end

  def perform
    melody_pitches = @tonality.melody_pitches
    melody_velocities = (50..75).to_a + [0, 0, 0, 0]
    compose_line(line: @melody,
                   pitches: melody_pitches,
                   velocities: melody_velocities,
                   rhythm: Rhythm.new)

    bass_pitches = @tonality.bass_pitches
    bass_rhythm = Rhythm.new(durations: [960, 480])
    compose_line(line: @bass,
                 pitches: bass_pitches,
                 velocities: (50..70).to_a,
                 rhythm: bass_rhythm)

    compose_line(line: @ostinato,
                 pitches: bass_pitches[0..0],
                 velocities: (50..65).to_a,
                 rhythm: Rhythm.new)

    4.times { @track0.events += @melody.events }
    4.times { @track1.events += @bass.events }
    4.times { @track2.events += @ostinato.events }

    write_midi_file
  end

  private

  def compose_line(line:, pitches:, velocities:, rhythm:)
    rhythm.events.each do |duration|
      pitch = line.compose_next_pitch(line.events.last&.note, pitches)
      velocity = velocities.sample
      line.events << NoteOn.new(0, pitch, velocity, 0)
      line.events << NoteOff.new(0, pitch, velocity, duration)
    end
  end

  def permute_note_events(events, pitches)
    indexes = (0..events.length).reject(&:odd?).to_a.shuffle.take(4)

    indexes.each do |index|
      new_pitch = pitches.sample
      events[index].note = new_pitch     # NoteOn
      events[index + 1].note = new_pitch # NoteOff
    end
    events
  end

  def write_midi_file
    file_name = "midi/#{Time.now}.mid"
    File.open(file_name, 'wb') { |file| @seq.write(file) }
  end
end

AmericanMinimalism.new.perform
