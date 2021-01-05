require "./spec_helper"

describe ULID do
  describe ".generate : String" do
    it "should not raise an error" do
      begin
        ULID.generate
      rescue err
        err.should be_nil
      end
    end

    it "should return correct length" do
      ULID.generate.size.should eq 26
    end

    it "should contain only correct chars" do
      (ULID.generate =~ /[^0123456789ABCDEFGHJKMNPQRSTVWXYZ]/).should be_nil
    end

    it "should be in upcase" do
      res = ULID.generate

      res.should eq res.upcase
    end

    it "should be unique" do
      len = 1000
      arr = [] of String

      len.times do
        arr << ULID.generate
      end

      arr.uniq!

      arr.size.should eq len
    end

    it "should be sortable" do
      1000.times do
        ulid_1 = ULID.generate
        sleep 1.millisecond
        ulid_2 = ULID.generate

        (ulid_2 > ulid_1).should be_true
      end
    end

    it "should be seedable" do
      1000.times do
        ulid_1 = ULID.generate
        sleep 1.millisecond
        ulid_2 = ULID.generate(Time.utc - 1.second)

        (ulid_2 < ulid_1).should be_true
      end
    end

    it "validator should return true if a string is a valid ulid" do
      validator = ULID.valid?("01B3EAF48P97R8MP9WS6MHDTZ3")
      validator.should eq true
    end

    it "should not valdate invalid strings" do
      ULID.valid?("0").should eq false
      ULID.valid?("01B3EAF48P97R8MP9WS6MHDTZ32").should eq false
      ULID.valid?("01b3EAF48P97R8MP9WS6MHDTZ3").should eq false
      ULID.valid?("01B3EAF48P97R8MP9WS6MHDTZ").should eq false
      ULID.valid?("!@#$%^&*(").should eq false
      ULID.valid?("abcde").should eq false
      ULID.valid?("1234567890").should eq false
      ULID.valid?("01!3EAF48P97R8MP9WS8MHDTZ3").should eq false
    end

    # test time decode method
  end
end
