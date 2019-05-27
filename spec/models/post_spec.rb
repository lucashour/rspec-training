require 'rails_helper'

RSpec.describe Post, type: :model do
  # En base al modelo de test propuesto para el modelo User,
  # implementar los tests para el modelo Post.
  describe 'Factory' do
    it 'has a valid factory' do
      build(:post).should be_valid
    end
  end

  describe 'Associations' do
    # Testear asociaciones (shoulda-matchers).
    it { should belong_to(:user) }
  end

  describe 'Presence validations' do
    # Testear validaciones de presencia (shoulda-matchers).
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  describe 'Uniqueness validations' do
    # Testear validaciones de unicidad (shoulda-matchers).
    subject{build(:post)} #PORQUE??
    it { should validate_uniqueness_of(:title) }
  end
end
