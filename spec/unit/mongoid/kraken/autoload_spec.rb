require "spec_helper"

describe Mongoid::Kraken::Autoload do

  context "when kraken object does not exist" do

    let(:star) do
      Star.create(:name => "MyStar")
    end

    after do
      Star.delete_all
    end

    it "has a nil kraken value" do
      star.reload.kraken_id.should be_nil
      star.reload.kraken.should be_nil
    end
  end

  context "when kraken object does exist" do

    after do
      Mongoid::Kraken::Kraken.delete_all
      Star.delete_all
    end

    it "should autoload the kraken object" do
      kraken = Mongoid::Kraken::Kraken.new(:name => "Star")
      expect { kraken.save }.to_not raise_error
      star = Star.new
      expect { star.save }.to_not raise_error
      star.kraken_id.should == kraken._id
      star.kraken.should == kraken
    end
  end

end
