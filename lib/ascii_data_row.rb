class AsciiDataRow
  class << self
    attr_reader :fields_definitions

    def fields_definitions
      @fields_definitions ||= {}
    end
  end

  def self.field(name, range, type)
    fields_definitions[name] = FieldDefinition.new(type, range)
  end

  def self.create_from(ascii_row)
    self.new(ascii_row)
  end

  def initialize(ascii_row)
    @fields = {}
    @ascii_row = ascii_row
    self.class.fields_definitions.each_pair {|name, definition| @fields[name] = get_value_for_field_definition(definition) }
  end

  def fields
    @fields
  end

  private
  def get_value_for_field_definition(definition)
    text_value = @ascii_row.slice(definition.range).strip
    return text_value if definition.type == :string
    if definition.type == :int
      return nil if text_value.empty?
      return text_value.to_i
    end

    if definition.type == :float
      return nil if text_value.empty?
      return text_value.to_f
    end

    if definition.type == :bool
      return text_value == '1'
    end

  end
end

class FieldDefinition
  attr_reader :type, :range

  def initialize(type, range)
    @type = type
    @range = Range.new(range.min-1, range.max-1)
  end
end
