require 'spec_helper'

describe RssRecord do
  it { should have_db_column(:owner_type).of_type(:string).with_options(null: false) }
  it { should have_db_column(:owner_id).of_type(:integer).with_options(null: false) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should have_db_index :created_at }
end
