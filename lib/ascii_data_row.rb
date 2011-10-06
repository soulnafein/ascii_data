require 'time'
require 'iconv'

class AsciiDataRow
  class << self
    attr_reader :fields_definitions

    def fields_definitions
      @fields_definitions ||= {}
    end
  end

  def self.field(name, range, type, options={})
    options[:format] ||= '%d/%m/%Y'
    fields_definitions[name] = FieldDefinition.new(type, range, options)
  end

  def self.create_from(ascii_row)
    self.new(ascii_row)
  end

  def initialize(ascii_row)
    @fields = {}
    @ascii_row = remove_invalid_utf8_bytes(ascii_row)
    self.class.fields_definitions.each_pair do |name, definition| 
      @fields[name] = get_value_for_field_definition(definition)
    end
  end

  def fields
    @fields
  end

  private
  def remove_invalid_utf8_bytes(a_string)
    @ic ||= Iconv.new('UTF-8//IGNORE', 'UTF-8')
    @ic.iconv(a_string)
  end

  def get_value_for_field_definition(definition)
    text_value = @ascii_row.slice(definition.range.min, definition.range.max).strip

    case definition.type
    when :string
      text_value
    when :int
      text_value.empty? ? nil : text_value.to_i
    when :float
      text_value.empty? ? nil : text_value.to_f
    when :date
      text_value.empty? ? nil : parse_date(text_value, definition.options[:format])
    when :bool
      text_value == '1'
    else
      nil
    end
  end

  def parse_date(text_value, format)
    if format == "%Y/%m/%d"
      year = text_value[0..3].to_i
      month = text_value[5..6].to_i
      day = text_value[8..9].to_i
      Time.utc(year, month, day)
    elsif format == "%d/%m/%Y"
      day = text_value[0..1].to_i
      month = text_value[3..4].to_i
      year = text_value[6..9].to_i
      Time.utc(year, month, day)
    else
      Time.strptime(text_value, format)
    end
  end
end

class FieldDefinition
  attr_reader :type, :range, :options

  def initialize(type, range, options)
    @type = type
    @range = Range.new(range.min-1, range.max-1)
    @options = options
  end
end
