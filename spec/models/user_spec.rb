require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(create(:user)).to be_valid
    end
  end

  describe 'Associations' do
    it 'has many posts' do
      expect have_many(:posts)
    end
  end

  describe 'Presence validations' do
    it 'has a not empty password' do
      expect validate_presence_of(:password)
    end

    it 'has a not empty email' do
      expect validate_presence_of(:email)
    end

    it 'has a not empty role' do
      expect validate_presence_of(:role)
    end
  end

  describe 'Uniqueness validations' do
    it 'has a unique email' do
      expect validate_uniqueness_of(:email)
    end
  end

  describe 'Length validations' do
    it 'has a valid length' do
      expect validate_length_of(:password).is_at_least(8)
    end
  end

  describe 'Enumeratives' do
    it 'has a role enum' do
      expect define_enum_for(:role).with([:admin, :regular])
    end

    describe 'when user is admin' do
      subject do
        create(:admin_user)
      end

      it 'has an admin role' do
        expect(subject.admin?).to be true
      end
    end

    describe 'when user is regular' do
      subject do
        create(:regular_user)
      end

      it 'has a regular role' do
        expect(subject.regular?).to be true
      end
    end
  end

  describe '#valid_password?' do
    let!(:password) { SecureRandom.hex }

    subject do
      create(:user)
    end

    context 'when given value is different from password' do
      it 'has to return false' do
        expect(subject.valid_password?(password)).to be false
      end
    end

    context 'when given value is equal to password' do
      it 'has to return true' do
        expect(subject.valid_password?(subject.password)).to be true
      end
    end
  end
end
