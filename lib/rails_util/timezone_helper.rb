require 'active_support/time'
require 'pry'

module RailsUtil
  # `RailsUtil::TimezoneHelper` contains helper methods for converting a time between timezones.
  # Uses `ActiveSupport::TimeZone` `timezone.tzinfo.name` names (e.g., 'America/Chicago') to identify timezones.
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
        converted_time = time + offset_in_seconds(to_timezone, from_timezone)
        timezone_with_offset(converted_time, to_timezone, options[:date])
      end

      private

      # Calculates the difference in time between the provided timezones
      # @param [Time, DateTime] time can be a Time or DateTime object, will use date of Time object if no date provided
      # @param [String] to_timezone the `ActiveSupport::TimeZone` `timezone.tzinfo.name` of the desired timezone
      # @param [String] to_timezone the `ActiveSupport::TimeZone` `timezone.tzinfo.name` of the timezone being converted
      # @return ActiveSupport::Duration object as the number of seconds between the given timezones
      def offset_in_seconds(to_timezone, from_timezone)
        time = Time.now
        (time.in_time_zone(to_timezone).utc_offset - time.in_time_zone(from_timezone).utc_offset).seconds
      end

      # Creates a DateTime object with the offset of the given timezone, a time of the time provided, and a date of either the date or time provided
      # @param [Time, DateTime] time can be a Time or DateTime object, will use date of Time object if no date provided
      # @param [String] timezone the `ActiveSupport::TimeZone` `timezone.tzinfo.name` of the desired timezone
      # @param [Date] date optional parameter to specify a date, otherwise the date of the provided time will be used
      # @return DateTime object in the given time with an offset of the given timezone
      def timezone_with_offset(time, timezone, date)
        date ||= time
        DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec, format_offset(timezone))
      end

      # Returns a string representation of the UTC offset for the given timezone
      # @param [String] timezone the `ActiveSupport::TimeZone` `timezone.tzinfo.name`
      # @return String object of the UTC offset of the given timezone
      def format_offset(timezone)
        offset = utc_offset(timezone).to_s
        offset.insert(1, '0') if utc_offset(timezone).abs < 10
        plus_sign = '+' unless offset.include? '-'
        [plus_sign, offset, ':00'].compact.join
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
