require 'rails_helper'

# VERSION 1
RSpec.describe ApiLoginManager do
  let!(:password) { SecureRandom.hex }

  let!(:user) { create(:user, password: password) }

  describe '#call' do
    context 'when user provided data is valid' do
      before do
        expect(ExternalValidator).to receive(:call).and_return(true)
      end

      subject do
        described_class.new(email: user.email, password: password).call
      end

      it "update user's auth_token" do
        expect { subject }.to change { user.reload.auth_token }
      end

      it 'returns the auth_token' do
        expect(subject).to eq user.reload.auth_token
      end
    end

    context 'when no email is provided' do
      subject { described_class.new(password: password) }

      it 'returns false' do
        expect(subject.call).to be_falsey
      end

      it 'returns EMPTY_EMAIL error with a reader' do
        subject.call
        expect(subject.error).to eq 'El email no puede estar en blanco'
      end
    end

    context 'when no password is provided' do
      subject { described_class.new(email: user.email) }

      it 'returns false' do
        expect(subject.call).to be_falsey
      end

      it 'returns EMPTY_PASSWORD error with a reader' do
        subject.call
        expect(subject.error).to eq 'La contraseña no puede estar en blanco'
      end
    end

    context 'when the email is incorrect' do
      subject do
        described_class.new(email: 'wrong@email.com', password: password)
      end

      it 'returns false' do
        expect(subject.call).to be_falsey
      end

      it 'returns USER_NOT_FOUND error with a reader' do
        subject.call
        expect(subject.error).to eq 'El usuario no existe'
      end
    end

    context 'when the password is incorrect' do
      subject do
        described_class.new(email: user.email, password: 'wrong_password')
      end

      it 'returns false' do
        expect(subject.call).to be_falsey
      end

      it 'returns WRONG_PASSWORD error with a reader' do
        subject.call
        expect(subject.error).to eq 'La contraseña es incorrecta'
      end
    end

    context 'when the external validation fail' do
      before do
        expect(ExternalValidator).to receive(:call).and_return(false)
      end

      subject do
        described_class.new(email: user.email, password: password)
      end

      it 'returns false' do
        expect(subject.call).to be_falsey
      end

      it 'returns WRONG_PASSWORD error with a reader' do
        subject.call
        expect(subject.error).to eq 'El usuario ya no tiene cuota disponible'
      end
    end
  end
end

# VERSION 2
RSpec.describe ApiLoginManager do
  let!(:user)    { create(:user, password: password) }
  let(:password) { SecureRandom.hex }

  let(:manager) do
    described_class.new(
      email:    auth_email,
      password: auth_password
    )
  end

  let(:auth_email)    { user.email }
  let(:auth_password) { password }

  describe '::USER_NOT_FOUND' do
    subject { described_class::USER_NOT_FOUND }

    it { is_expected.to eq 'El usuario no existe'}
    it { is_expected.to be_frozen }
  end

  describe '::EMPTY_EMAIL' do
    subject { described_class::EMPTY_EMAIL }

    it { is_expected.to eq 'El email no puede estar en blanco'}
    it { is_expected.to be_frozen }
  end

  describe '::EMPTY_PASSWORD' do
    subject { described_class::EMPTY_PASSWORD }

    it { is_expected.to eq 'La contraseña no puede estar en blanco'}
    it { is_expected.to be_frozen }
  end

  describe '::WRONG_PASSWORD' do
    subject { described_class::WRONG_PASSWORD }

    it { is_expected.to eq 'La contraseña es incorrecta'}
    it { is_expected.to be_frozen }
  end

  describe '::EXTERNAL_VALIDATOR' do
    subject { described_class::EXTERNAL_VALIDATOR }

    it { is_expected.to eq 'El usuario ya no tiene cuota disponible'}
    it { is_expected.to be_frozen }
  end

  describe '::ERRORS' do
    subject { described_class::ERRORS }

    it do
      is_expected.to match_array [
        described_class::USER_NOT_FOUND,
        described_class::EMPTY_EMAIL,
        described_class::EMPTY_PASSWORD,
        described_class::WRONG_PASSWORD,
        described_class::EXTERNAL_VALIDATOR
      ]
    end
    it { is_expected.to be_frozen }
  end

  describe '#call' do
    subject { manager.call }

    context 'when user provided data is valid' do
      before do
        expect(ExternalValidator).to receive(:call).and_return(true)
      end

      it "update user's auth_token" do
        expect { subject }.to change { user.reload.auth_token }
      end

      it 'returns the auth_token' do
        is_expected.to eq user.reload.auth_token
      end
    end

    context 'when no email is provided' do
      let(:auth_email) { nil }

      it 'returns false' do
        is_expected.to be_falsey
      end
    end

    context 'when no password is provided' do
      let(:auth_password) { nil }

      it 'returns false' do
        is_expected.to be_falsey
      end
    end

    context 'when the email is incorrect' do
      let(:auth_email) { 'wrong@email.com' }

      it 'returns false' do
        is_expected.to be_falsey
      end
    end

    context 'when the password is incorrect' do
      let(:auth_password) { 'wrong_password' }

      it 'returns false' do
        is_expected.to be_falsey
      end
    end

    context 'when the external validation fail' do
      before do
        expect(ExternalValidator).to receive(:call).and_return(false)
      end

      it 'returns false' do
        is_expected.to be_falsey
      end
    end
  end

  describe '#error' do
    before  { manager.call }
    subject { manager.error }

    context 'when user provided data is valid' do
      before do
        expect(ExternalValidator).to receive(:call).and_return(true)
        manager.call
      end

      it 'does not return error' do
        is_expected.to be_blank
      end
    end

    context 'when no email is provided' do
      let(:auth_email) { nil }

      it 'returns EMPTY_EMAIL error' do
        is_expected.to eq described_class::EMPTY_EMAIL
      end
    end

    context 'when no password is provided' do
      let(:auth_password) { nil }

      it 'returns EMPTY_PASSWORD error' do
        is_expected.to eq described_class::EMPTY_PASSWORD
      end
    end

    context 'when the email is incorrect' do
      let(:auth_email) { 'wrong@email.com' }

      it 'returns USER_NOT_FOUND error' do
        is_expected.to eq described_class::USER_NOT_FOUND
      end
    end

    context 'when the password is incorrect' do
      let(:auth_password) { 'wrong_password' }

      it 'returns WRONG_PASSWORD error' do
        is_expected.to eq described_class::WRONG_PASSWORD
      end
    end

    context 'when the external validation fail' do
      before do
        expect(ExternalValidator).to receive(:call).and_return(false)
        manager.call
      end

      it 'returns EXTERNAL_VALIDATOR error' do
        is_expected.to eq described_class::EXTERNAL_VALIDATOR
      end
    end
  end
end
