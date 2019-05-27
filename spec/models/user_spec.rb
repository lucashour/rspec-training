require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  describe 'Associations' do
    it { should have_many(:posts) }
    # https://github.com/thoughtbot/shoulda-matchers#activerecord-matchers
  end

  describe 'Presence validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:role) }
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
  end

  describe 'Uniqueness validations' do
    subject { create(:user) }
    it { should validate_uniqueness_of(:email) }
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
  end

  describe 'Length validations' do
    it { should validate_length_of(:password).is_at_least(8) }
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
  end

  describe 'Enumeratives' do
    it { should define_enum_for(:role) }
  end

  describe '#valid_password?' do
    subject { create(:user) }
    context 'when given value is different from password' do
      it 'returns false' do
        expect(subject.valid_password?(SecureRandom.uuid)).to be_falsey
      end
    end

    context 'when given value is equal to password' do
      it 'returns true' do
        expect(subject.valid_password?(subject.password)).to be
      end
    end

    # Testear funcionamiento de método. Podemos definir dos contexts:
    #  - 'when given value is different from password'
    #  - 'when given value is equal to password'
  end
end
