require 'byebug'
require 'midilib/sequence'
require 'midilib/consts'

require './tonality'
require './melody'
require './rhythm'

class AmericanMinimalism
  include MIDI

  def initialize(melody:, tonality:)
    # A MIDI::Sequence contains MIDI::Track objects.
    @seq = Sequence.new

    tempo = Tempo.bpm_to_mpq(120)

    # Create two tracks to hold the notes. Add it to the sequence.
    @track0 = Track.new(@seq)
    @seq.tracks << @track0
    @track0.name = 'melody'
    @track0.events << Tempo.new(tempo)

    # @track1 = Track.new(@seq)
    # @seq.tracks << @track1
    # @track1.name = 'bass'

    # set the tonality aka scale
    @tonality = tonality
    @melody = melody
  end

  def perform
    melody_pitches = @tonality.melody_pitches
    compose_melody(melody_pitches)

    # bass_pitches = @tonality.melody_pitches
    # composs_bass(bass_pitches)

    write_midi_file
  end

  private

  def compose_melody(melody_pitches)
    # take a breath

    # set a range of medium velocity (how 'hard' the pitch is struck)
    velocities = (60..95).to_a + [0, 0, 0, 0]

    rhythm = Rhythm.new

    rhythm.events.each do |duration|
      pitch = compose_next_pitch(@melody.events.last&.note, melody_pitches)
      velocity = velocities.sample
      @melody.events << NoteOn.new(0, pitch, velocity, 0)
      @melody.events << NoteOff.new(0, pitch, velocity, duration)
    end

    @melody.events += permute_note_events(@melody.events.clone, melody_pitches)

    # 4.times { write_events_to_track(@melody.events, @track0) }
    4.times { @track0.events += @melody.events }



    # melody_variation.each do |note_event|
    #   @track0.events << note_event
    # end

    # base_pitch = 40

    # 8.times do
    #   pitch = base_pitch + bass_pitch_offsets.sample
    #   velocity = velocities.sample
    #   bass_line << NoteOn.new(0, pitch, velocity, 0)
    #   bass_line << NoteOff.new(0, pitch, velocity, 960)
    # end
    # 3.times do
    #   bass_line.each do |note_event|
    #     @track1.events << note_event
    #   end
    # end
  end

  def compose_next_pitch(previous_pitch, melody_pitches)
    return melody_pitches.sample if previous_pitch.nil?

    return melody_pitches.sample unless (-1..5).to_a.sample.positive?

    previous_pitch_index = melody_pitches.index(previous_pitch)
    next_pitch_index = previous_pitch_index + [-1, 1].sample
    melody_pitches[next_pitch_index]
  end

  def permute_note_events(events, pitches)
    indexes = (0..events.length).reject(&:odd?).to_a.shuffle.take(4)
    indexes.each do |index|
      new_pitch = pitches.sample
      events[index].note = new_pitch     # NoteOn
      events[index + 1].note = new_pitch # NoteOff
    end
    events


    # even_numbers = (8..31).to_a.reject(&:odd?)
    # 2.times do
    #   begin
    #     new_pitch = melody_pitches.sample
    #     index     = even_numbers.sample
    #     melody_variation[index].note     = new_pitch
    #     melody_variation[index + 1].note = new_pitch
    #   end
    # end
  end

  def write_events_to_track(events, track)
    track.events += events
  end

  def write_midi_file
    file_name = "midi/#{Time.now}.mid"
    File.open(file_name, 'wb') { |file| @seq.write(file) }
  end
end

AmericanMinimalism
  .new(
    melody: Melody.new,
    tonality: Tonality.new
  )
  .perform
