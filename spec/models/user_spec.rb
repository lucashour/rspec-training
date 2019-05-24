require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      # Testear que el factory definido es válido.
      expect(FactoryBot.create(:user)).to be_valid
    end
  end

  describe 'Associations' do
    # Testear asociaciones (shoulda-matchers).
    # https://github.com/thoughtbot/shoulda-matchers#activerecord-matchers
    it { is_expected.to have_many(:posts).dependent(:destroy) }
  end

  describe 'Presence validations' do
    # Testear validaciones de presencia (shoulda-matchers).
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:role) }
  end

  describe 'Uniqueness validations' do
    # Testear validaciones de unicidad (shoulda-matchers).
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
    let!(:subject) { FactoryBot.create(:user) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe 'Length validations' do
    # Testear validaciones de longitud (shoulda-matchers).
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
  end

  describe 'Enumeratives' do
    # Testear definición de enumerativos (shoulda-matchers).
    it { is_expected.to define_enum_for(:role).with([:admin, :regular])}
  end

  # Testear métodos de instancia y de clase como para el caso de cualquier
  # otra clase Ruby (similar a testear ApiLoginManager).
  describe '#valid_password?' do
    # Testear funcionamiento de método. Podemos definir dos contexts:
    #  - 'when given value is different from password'
    #  - 'when given value is equal to password'
    context 'when given value is different from password' do
      let!(:subject) { FactoryBot.create(:user, password: 'password') }

      it 'returns false' do
        expect(subject.valid_password?('passw0rd')).to be false
      end
    end

    context 'when given value is equal to password' do
      let!(:subject) { FactoryBot.create(:user, password: 'password') }

      it 'returns true' do
        expect(subject.valid_password?('password')).to be true
      end
    end    
  end
end
