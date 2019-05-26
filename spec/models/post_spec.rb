require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(create(:post)).to be_valid
    end
  end

  describe 'Associations' do
    it 'belong to an user' do
      expect belong_to(:user)
    end
  end

  describe 'Presence validations' do
    it 'has a not empty title' do
      expect validate_presence_of(:title)
    end

    it 'has a not empty body' do
      expect validate_presence_of(:body)
    end
  end

  describe 'Uniqueness validations' do
    it 'has a unique title' do
      expect validate_uniqueness_of(:title)
    end
  end
end
