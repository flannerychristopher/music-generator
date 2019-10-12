#! /usr/bin/env ruby
#
# usage: from_scratch.rb
#
# This script shows you how to create a new sequence from scratch and save it
# to a MIDI file. It creates a file called 'from_scratch.mid'.

# Start looking for MIDI module classes in the directory above this one.
# This forces us to use the local copy, even if there is a previously
# installed version out there somewhere.
$LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')

require 'midilib/sequence'
require 'midilib/consts'
include MIDI

seq = Sequence.new()

# Create a first track for the sequence. This holds tempo events and stuff
# like that.
track = Track.new(seq)
seq.tracks << track
track.events << Tempo.new(Tempo.bpm_to_mpq(120))
track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')

# Create a track to hold the notes. Add it to the sequence.
track = Track.new(seq)
seq.tracks << track

# Give the track a name and an instrument name (optional).
track.name = 'melody'
# track.instrument = GM_PATCH_NAMES[0]

# Add a volume controller event (optional).
track.events << Controller.new(0, CC_VOLUME, 127)

# note lengths

# Add events to the track: a major scale. Arguments for note on and note off
# constructors are channel, note, velocity, and delta_time. Channel numbers
# start at zero. We use the new Sequence#note_to_delta method to get the
# delta time length of a single quarter note.
track.events << ProgramChange.new(0, 1, 0)
# quarter_note_length = seq.note_to_delta('eighth')
# tones = [-4, -2, 0, 2, 4, 7, 9, 12, 14, 16].shuffle.tap { |x| x.pop 2 }
# tones.each do |offset|
  #   track.events << NoteOn.new(0, 64 + offset, 127, 0)
  #   track.events << NoteOff.new(0, 64 + offset, 127, note_lengths.sample)
  # end

base_pitch = 64
note_lengths = [  480, 480, #quarter
                  240, 240, 240,
                  120, 120, 120, 120, 120, 120,
                  60, 60, 60, 60 ]
pitch_offsets = [-5, -3, 0, 2, 4, 7, 9, 12, 14, 16]
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
    track.events << note_event
  end
  ostinato_variation.each do |note_event|
    track.events << note_event
  end
end

# Calling recalc_times is not necessary, because that only sets the events'
# start times, which are not written out to the MIDI file. The delta times are
# what get written out.

track.recalc_times

# bass

track2 = Track.new(seq)
seq.tracks << track2
track2.name = 'bass'

track2.events << NoteOff.new(0, 0, 0, 7680)

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
    track2.events << note_event
  end
end

File.open('from_scratch.mid', 'wb') { |file| seq.write(file) }

