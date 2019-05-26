# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    subject { build(:user) }

    it 'has a valid factory' do
      is_expected.to be_valid
    end
  end

  describe 'Associations' do
    it { should have_many(:posts).dependent(:destroy) }
  end

  describe 'Presence validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:role) }
  end

  describe 'Uniqueness validations' do
    subject { create(:user) }

    it { should validate_uniqueness_of(:email) }
  end

  describe 'Length validations' do
    it { should validate_length_of(:password).is_at_least(8) }
  end

  describe 'Enumeratives' do
    it { should define_enum_for(:role).with_values([:admin, :regular]) }
  end

  describe '#valid_password?' do
    subject { user.valid_password?(password) }

    let(:user) { create(:user, password: 'password_secret') }

    context 'when given value is different from password' do
      let(:password) { 'password_wrong' }

      it { is_expected.to be_falsey }
    end

    context 'when given value is equal to password' do
      let(:password) { 'password_secret' }

      it { is_expected.to be_truthy }
    end
  end
end
