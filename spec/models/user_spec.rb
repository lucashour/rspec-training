require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      build(:user).should be_valid
    end
  end

  describe 'Associations' do
    # Testear asociaciones (shoulda-matchers).
    it { should have_many(:posts) }
  end

  describe 'Presence validations' do
    # Testear validaciones de presencia (shoulda-matchers).
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:role) }
  end
  
  describe 'Uniqueness validations' do
    # Testear validaciones de unicidad (shoulda-matchers).
    subject{build(:user)} #PORQUE??
    it { should validate_uniqueness_of(:email) }
  end
  describe 'Length validations' do
    # Testear validaciones de longitud (shoulda-matchers).
    it { should validate_length_of(:password).is_at_least(8) }
  end

  describe 'Enumeratives' do
    it{ should define_enum_for(:role).with([:admin, :regular]) }
  end

  # Testear métodos de instancia y de clase como para el caso de cualquier
  # otra clase Ruby (similar a testear ApiLoginManager).
  describe '#valid_password?' do
    let!(:password) { SecureRandom.hex }

    let!(:user) { FactoryBot.create(:user, password: password) } 
    context 'when given value is equal to password' do
      subject do
        build(:user, password: password).valid_password?(password)
      end

      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'when given value is different from password' do
      subject do
        build(:user, password: password).valid_password?('sarasa')
      end

      it 'returns false' do
        expect(subject).to be false
      end
    end

  end
end
