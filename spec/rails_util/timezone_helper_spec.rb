require 'spec_helper'

describe RailsUtil::TimezoneHelper do
  let(:timezone) { 'America/Chicago' } # currently 5 hours behind UTC
  let(:time) { Time.new(2000, 1, 1, 7, 30, 0) } # arbitrary date, timezone agnostic time
  let(:date) { Date.new(2017, 9, 27) }

  describe '#convert_to_utc' do
    context 'no specific date provided' do
      let(:subject) { RailsUtil::TimezoneHelper.convert_to_utc(timezone, time) }

      it 'returns UTC' do
        utc_time = DateTime.new(2000, 1, 1, 12, 30, 0, '+00:00')
        expect(subject).to eq(utc_time)
      end
    end

    context 'specific date provided' do
      let(:subject) { RailsUtil::TimezoneHelper.convert_to_utc(timezone, time, date: date) }

      it 'returns UTC' do
        utc_time = DateTime.new(2017, 9, 27, 12, 30, 0, '+00:00')
        expect(subject).to eq(utc_time)
      end
    end
  end

  describe '#convert_from_utc' do
    context 'no specific date provided' do
      let(:subject) { RailsUtil::TimezoneHelper.convert_from_utc(timezone, time) }

      it 'returns Chicago' do
        utc_time = DateTime.new(2000, 1, 1, 2, 30, 0, '-05:00')
        expect(subject).to eq(utc_time)
      end
    end

    context 'specific date provided' do
      let(:subject) { RailsUtil::TimezoneHelper.convert_from_utc(timezone, time, date: date) }

      it 'returns Chicago' do
        utc_time = DateTime.new(2017, 9, 27, 2, 30, 0, '-05:00')
        expect(subject).to eq(utc_time)
      end
    end
  end

  describe 'conversion logic' do
    describe '#convert_time_zone' do
      let(:subject) { RailsUtil::TimezoneHelper.send(:convert_time_zone, timezone, time) }

      it 'returns Chicago' do
        time_with_offset = DateTime.new(2000, 1, 1, 7, 30, 0, '-05:00')
        expect(subject).to eq(time_with_offset)
      end
    end

    context 'specific date provided' do
      let(:subject) { RailsUtil::TimezoneHelper.send(:convert_time_zone, timezone, time, date: date) }
      it 'returns UTC' do
        time_with_offset = DateTime.new(2017, 9, 27, 7, 30, 0, '-05:00')
        expect(subject).to eq(time_with_offset)
      end
    end

    describe '#format_offset' do
      let(:subject) { RailsUtil::TimezoneHelper.send(:format_offset, timezone) }
      it { is_expected.to eq('-05:00') }
    end

    describe '#format_offset' do
      let(:subject) { RailsUtil::TimezoneHelper.send(:utc_offset, timezone) }
      it { is_expected.to eq(-5) }
    end
  end
end
