# frozen_string_literal: true

require 'tonality'
require 'byebug'

describe Tonality do

  describe '@scale' do
    shared_examples 'it initializes the instance variable' do |parameter, expected_result|
      let(:class_instance) { described_class.new(parameter) }

      it 'intializes formats the input' do
        expect(class_instance.scale).to eq expected_result
      end
    end

    context 'the input is integers 0 to 11' do
      parameter = (0..11).to_a
      it_behaves_like 'it initializes the instance variable', parameter, parameter
    end

    context 'some integers are greater than 11' do
      parameter = [0, 14, 15, 1]
      expected_result = [0, 1, 2, 3]
      it_behaves_like 'it initializes the instance variable', parameter, expected_result
    end

    context 'all integers are greater than 11' do
      parameter = [36, 50, 64, 41, 55, 57, 71].shuffle
      expected_result = [0, 2, 4, 5, 7, 9, 11]
      it_behaves_like 'it initializes the instance variable', parameter, expected_result
    end
  end

  describe '#pitches' do
    let(:all_pitches) { (0..127).to_a }

    it 'extends scale over full range' do
      # expect(subject.pitches).to eq all_pitches
    end
  end
end
