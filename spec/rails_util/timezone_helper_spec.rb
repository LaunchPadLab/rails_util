require 'spec_helper'

describe RailsUtil::TimezoneHelper do
  let(:timezone) { 'America/Chicago' } # currently 5 hours behind UTC
  let(:time) { Time.new(2000, 1, 1, 7, 30, 0) } # arbitrary date, timezone agnostic time
  let(:date) { Date.new(2017, 9, 27) }

  let(:subject) { RailsUtil::TimezoneHelper }

  describe '#convert_to_utc' do
    it 'no date provided' do
      utc_time = DateTime.new(2000, 1, 1, 12, 30, 0, '+00:00')
      expect(subject.convert_to_utc(timezone, time)).to eq(utc_time)
    end

    it 'specific date provided' do
      utc_time = DateTime.new(2017, 9, 27, 12, 30, 0, '+00:00')
      expect(subject.convert_to_utc(timezone, time, date: date)).to eq(utc_time)
    end
  end

  describe '#convert_from_utc' do
    it 'no date provided' do
      chicago_time = DateTime.new(2000, 1, 1, 2, 30, 0, '-05:00')
      expect(subject.convert_from_utc(timezone, time)).to eq(chicago_time)
    end

    it 'specific date provided' do
      chicago_time = DateTime.new(2017, 9, 27, 2, 30, 0, '-05:00')
      expect(subject.convert_from_utc(timezone, time, date: date)).to eq(chicago_time)
    end
  end

  describe '#convert_time_zone' do
    it 'no date provided' do
      time_with_offset = DateTime.new(2000, 1, 1, 7, 30, 0, '-05:00')
      expect(subject.send(:convert_time_zone, timezone, time)).to eq(time_with_offset)
    end

    it 'specific date provided' do
      time_with_offset = DateTime.new(2017, 9, 27, 7, 30, 0, '-05:00')
      expect(subject.send(:convert_time_zone, timezone, time, date: date)).to eq(time_with_offset)
    end
  end

  it '#format_offset' do
    expect(subject.send(:format_offset, timezone)).to eq('-05:00')
  end

  it '#futc_offset' do
    expect(subject.send(:utc_offset, timezone)).to eq(-5)
  end
end
