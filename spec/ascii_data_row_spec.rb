require 'spec_helper'

describe AsciiDataRow do
  context "when parsing a ascii data row" do
    #    1-5         5      CLHB     CAP Vehicle Identification Number
    #    6-15        10     CLHB     Technical Data Date (dd/mm/yyyy)
    #    16-18       3      CL B     Insurance Group 1
    #    19-21       3         B     Insurance Group 2
    #    22-31       10     CLHB     Kerb Weight (kg) (Dry Weight for BIKES)
    #    32-41       10     CLHB     Length (mm)
    #    42-51       10     CLHB     Width (mm)
    ASCII_LINE = %q{4404201/01/2010 13         1035      3657      1627}

    it "should load strings in a certain ranges" do
      class Row < AsciiDataRow
        field :vehicle_id_number, 1..5, :string
      end

      row = Row.create_from(ASCII_LINE)

      row.fields[:vehicle_id_number].should == "44042"
    end

    it "should trim spaces at the beginning and the end of string values" do
      class Row < AsciiDataRow
        field :kerb_weight_as_text, 22..31, :string
      end

      row = Row.create_from(ASCII_LINE)

      row.fields[:kerb_weight_as_text].should == "1035"
    end

    it "should parse integers correctly" do
      class Row < AsciiDataRow
        field :insurance_group_1, 16..18, :int
        field :insurance_group_2, 19..21, :int
        field :kerb_weight, 22..31, :int
      end

      row = Row.create_from(ASCII_LINE)

      row.fields[:insurance_group_1].should == 13
      row.fields[:insurance_group_2].should be_nil
      row.fields[:kerb_weight].should == 1035
    end
  end
end