require 'midilib/sequence'
require 'midilib/consts'
class Melody
  include MIDI

  def initialize
    # A MIDI::Sequence contains MIDI::Track objects.
    @seq = Sequence.new

    # Create a track to hold the notes. Add it to the sequence.
    @track = Track.new(@seq)
    @seq.tracks << @track
  end

  def perform
    base_pitch = 64
    pitch_offsets = [-5, -3, 0, 2, 4, 7, 9, 12, 14, 16]

    note_lengths = [  480, 480, #quarter
                      240, 240, 240,
                      120, 120, 120, 120, 120, 120,
                      60, 60, 60, 60 ]
    bass_pitch_offsets = [-5, -3, 0, 4, 7, 9, 12]
    velocities = (60..95).to_a
    ostinato = []

    16.times do
      pitch = base_pitch + pitch_offsets.sample
      velocity = velocities.sample
      ostinato << NoteOn.new(0, pitch, velocity, 0)
      ostinato << NoteOff.new(0, pitch, velocity, 240)
    end

    # make a variation with a few notes altered
    ostinato_variation = ostinato.map(&:clone)
    even_numbers = (8..31).to_a.reject { |int| int.odd? }
    2.times do
      begin
        new_pitch = base_pitch + pitch_offsets.sample
        index     = even_numbers.sample
        ostinato_variation[index].note     = new_pitch
        ostinato_variation[index + 1].note = new_pitch
      rescue Exception => e
        puts e.message
      end
    end

    4.times do
      ostinato.each do |note_event|
        @track.events << note_event
      end
      ostinato_variation.each do |note_event|
        @track.events << note_event
      end
    end

    # Calling recalc_times is not necessary, because that only sets the events'
    # start times, which are not written out to the MIDI file. The delta times are
    # what get written out.

    @track.recalc_times

    # bass

    @track2 = Track.new(@seq)
    @seq.tracks << @track2
    @track2.name = 'bass'

    @track2.events << NoteOff.new(0, 0, 0, 7680)

    bass_line = []
    base_pitch = 40

    8.times do
      pitch = base_pitch + bass_pitch_offsets.sample
      velocity = velocities.sample
      bass_line << NoteOn.new(0, pitch, velocity, 0)
      bass_line << NoteOff.new(0, pitch, velocity, 960)
    end
    3.times do
      bass_line.each do |note_event|
        @track2.events << note_event
      end
    end

    write_midi_file
  end

  private

  def write_midi_file
    file_name = "midi/#{Time.now}.mid"
    File.open(file_name, 'wb') { |file| @seq.write(file) }
  end
end

Melody.new.perform