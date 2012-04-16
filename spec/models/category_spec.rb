require 'spec_helper'

describe Category do
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:is_photo).of_type(:boolean).with_options(:default => false) }

  it { should have_db_index(:title).unique(true) }
  it { should have_db_index(:is_photo) }

  it { should validate_presence_of(:title) }

  describe "instance" do
    before :each do
      FactoryGirl.create(:category)
    end

    it { should validate_uniqueness_of(:title) }
  end

  describe "generators" do
    before :each do
      @category = FactoryGirl.create(:category)
    end

    it "should be valid" do
      @category.should be_valid
    end
  end
end
