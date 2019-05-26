require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      # Testear que el factory definido es válido.
      expect(build(:user)).to be_valid
    end
  end

  describe 'Associations' do
    # Testear asociaciones (shoulda-matchers).
    # https://github.com/thoughtbot/shoulda-matchers#activerecord-matchers
    it { should have_many(:posts).dependent(:destroy) }
  end

  describe 'Presence validations' do
    # Testear validaciones de presencia (shoulda-matchers).
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:role) }    
  end

  describe 'Uniqueness validations' do
    subject { create(:user) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    # Testear validaciones de unicidad (shoulda-matchers).
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
  end

  describe 'Length validations' do
    # Testear validaciones de longitud (shoulda-matchers).
    # https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
    it { should validate_length_of(:password).is_at_least(8) }
  end

  describe 'Enumeratives' do
    # Testear definición de enumerativos (shoulda-matchers).
    it { should define_enum_for(:role) }
  end

  # Testear métodos de instancia y de clase como para el caso de cualquier
  # otra clase Ruby (similar a testear ApiLoginManager).
  describe '#valid_password?' do
    # Testear funcionamiento de método. Podemos definir dos contexts:
    subject { create(:user) }
     
    context 'when given value is different from password' do
      it 'returns false' do
        expect(subject.valid_password?('1234')).to be false
      end
    end

    context 'when given value is equal to password' do
      it 'returns false' do
        expect(subject.valid_password?(subject.password)).to be true
      end
    end

  end
end
