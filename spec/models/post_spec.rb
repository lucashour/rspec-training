# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Factory' do
    subject { build(:post) }

    it 'has a valid factory' do
      is_expected.to be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
  end

  describe 'Presence validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  describe 'Uniqueness validations' do
    subject { create(:post) }

    it { should validate_uniqueness_of(:title) }
  end
end
