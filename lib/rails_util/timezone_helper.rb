require 'active_support/time'

module RailsUtil
  # `RailsUtil::TimezoneHelper` contains helper methods for converting a time between timezones
  module TimezoneHelper
    class << self
      SECONDS_PER_HOUR = 3600

      # Converts a time between a `from_timezone` and a `to_timezone`
      # @param [Time, DateTime] time can be a Time or DateTime object, will use the date of this argument if date not provided separately
      # @param [String] to_timezone the `ActiveSupport::TimeZone` `timezone.tzinfo.name` of the desired timezone
      # @param [String] from_timezone the `ActiveSupport::TimeZone` `timezone.tzinfo.name` of the timezone being converted
      # @param [Symbol=>[Date]] options key-value option pairs, used to provide a separate Date object if a specific date is needed, otherwise the date of the time argument is used
      # @return DateTime object with the time in the desired `to_timezone`, and a date of either the provided date or time
      def convert_timezone(time, to_timezone, from_timezone, **options)
        date = options.fetch(:date, time)
        utc_time = convert_to_utc(time, from_timezone, date)
        convert_from_utc(utc_time, to_timezone, date)
      end

      private

      # Returns the time in the given timezone converted to UTC with the formatted offset
      # @param [String] from_timezone the `ActiveSupport::TimeZone` `timezone.tzinfo.name` of the timezone being converted
      # @param [Time, DateTime] time can be a Time or DateTime object, will use date of Time object if no date provided
      # @param [Time, DateTime] date optional parameter to specify a date, otherwise the date of the provided time will be used
      # @return DateTime object with the time in UTC, and a date of either the provided date or time
      def convert_to_utc(time, from_timezone, date=nil)
        date ||= time
        timezone_with_offset(time, from_timezone, date).utc
      end

      # Returns the time in UTC converted to the given timezone with the formatted offset
      # @param [String] to_timezone the `ActiveSupport::TimeZone` `timezone.tzinfo.name` of the desired timezone
      # @param [Time, DateTime] time can be a Time or DateTime object, will use date of Time object if no date provided
      # @param [Time, DateTime] date optional parameter to specify a date, otherwise the date of the provided time will be used
      # @return DateTime object with the time in the given timezone, and a date of either the provided date or time
      def convert_from_utc(time, to_timezone, date=nil)
        date ||= time
        time += utc_offset(to_timezone).hours
        timezone_with_offset(time, to_timezone, date)
      end

      # Creates a DateTime object with the offset of the given timezone, a time of the time provided, and a date of either the date or time provided
      # @param [String] timezone the `ActiveSupport::TimeZone` `timezone.tzinfo.name` of the desired timezone
      # @param [Time, DateTime] time can be a Time or DateTime object, will use date of Time object if no date provided
      # @param [Time, DateTime] date optional parameter to specify a date, otherwise the date of the provided time will be used
      # @return DateTime object in the given time with an offset of the given timezone
      def timezone_with_offset(time, timezone, date=nil)
        date ||= time
        DateTime.new(date.year, date.month, date.day, time.hour, time.min, 0, format_offset(timezone))
      end

      # Returns a string representation of the UTC offset for the given timezone
      # @param [String] timezone the `ActiveSupport::TimeZone` `timezone.tzinfo.name`
      # @return String object of the UTC offset of the given timezone
      def format_offset(timezone)
        offset = utc_offset(timezone).to_s
        offset.insert(1, '0') if utc_offset(timezone).abs < 10
        offset + ':00'
      end

      # Returns a fixnum representation of the UTC offset for the given timezone in hours, taking into account whether Daylight Savings Time is in effect
      # @param [String] timezone the `ActiveSupport::TimeZone` `timezone.tzinfo.name`
      # @return FixNum object of the UTC offset of the given timezone
      def utc_offset(timezone)
        TZInfo::Timezone.get(timezone).current_period.utc_total_offset / SECONDS_PER_HOUR
      end
    end
  end
end
