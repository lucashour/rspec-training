require 'rails_helper'

RSpec.describe Post, type: :model do
  # En base al modelo de test propuesto para el modelo User,
  # implementar los tests para el modelo Post.
  describe 'Factory' do
    it 'has a valid factory' do
      # Testear que el factory definido es válido.
      expect(FactoryBot.create(:post)).to be_valid
    end
  end

  describe 'Associations' do
    # Testear asociaciones (shoulda-matchers).
    # https://github.com/thoughtbot/shoulda-matchers#activerecord-matchers
    it { is_expected.to belong_to(:user) }
  end

  describe 'Presence validations' do
    # Testear validaciones de presencia (shoulda-matchers).
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }    
  end

  describe 'Uniqueness validations' do
    # Testear validaciones de unicidad (shoulda-matchers).
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
    let!(:subject) { FactoryBot.create(:post) }
    it { is_expected.to validate_uniqueness_of(:title) }    
  end
end
