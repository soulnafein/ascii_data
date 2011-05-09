require File.dirname(__FILE__) + '/spec_helper'

describe AsciiDataRow do
  context "when parsing a ascii data row" do
    #    1-5         5      CLHB     CAP Vehicle Identification Number
    #    6-15        10     CLHB     Technical Data Date (dd/mm/yyyy)
    #    16-18       3      CL B     Insurance Group 1
    #    19-21       3         B     Insurance Group 2
    #    22-31       10     CLHB     Kerb Weight (kg) (Dry Weight for BIKES)
    #    32-41       10     CLHB     Length (mm)
    #    42-53       10     CLHB     Width (mm)
    ASCII_LINE = %q{4404201/01/2010 13         1035      3657      1627.23}

    it "should load strings in a certain ranges" do
      class RowA < AsciiDataRow
        field :vehicle_id_number, 1..5, :string
      end

      row = RowA.create_from(ASCII_LINE)

      row.fields[:vehicle_id_number].should == "44042"
    end

    it "should trim spaces at the beginning and the end of string values" do
      class RowB < AsciiDataRow
        field :kerb_weight_as_text, 22..31, :string
      end

      row = RowB.create_from(ASCII_LINE)

      row.fields[:kerb_weight_as_text].should == "1035"
    end

    it "should parse integers correctly" do
      class RowC < AsciiDataRow
        field :insurance_group_1, 16..18, :int
        field :insurance_group_2, 19..21, :int
        field :kerb_weight, 22..31, :int
      end

      row = RowC.create_from(ASCII_LINE)

      row.fields[:insurance_group_1].should == 13
      row.fields[:insurance_group_2].should be_nil
      row.fields[:kerb_weight].should == 1035
    end

    it "should parse floats correctly" do
      class RowD < AsciiDataRow
        field :width, 42..54, :float
      end

      row = RowD.create_from(ASCII_LINE)

      row.fields[:width].should == 1627.23
    end

    it "should parse bools correctly" do
      class RowE < AsciiDataRow
        field :flag_1, 3..3, :bool
        field :flag_2, 5..5, :bool
      end

      row = RowE.create_from("  1 0")

      row.fields[:flag_1].should be_true
      row.fields[:flag_2].should be_false
    end

    it "should fucking work" do
      class B < AsciiDataRow
        field :field_1, 4..4, :int
      end

      puts B.fields_definitions
    end
  end
end