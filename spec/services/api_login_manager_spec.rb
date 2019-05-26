require 'rails_helper'

RSpec.describe ApiLoginManager do
  let!(:password) { SecureRandom.hex }

  let!(:user) { create(:user, password: password) }

  describe '#call' do
    context 'when user provided data is valid' do
      before do
        allow(ExternalValidator).to receive(:call).and_return(true)
      end

      subject do
        described_class.new(email: user.email, password: password).call
      end

      it "update user's auth_token" do
        # skip 'Una vez que definan a user, este test va a fallar. ¿Por qué?'

        # Esto es porque el registro no se actualizo con los datos modificados
        # luego de la llamada a ApiLoginManager, por lo que es necesario hacer
        # un reload

        expect { subject }.to change { user.reload.auth_token }
      end

      it 'returns the auth_token' do
        expect(subject).to eq(user.reload.auth_token)
        # Por qué esto no anda pero lo de arriba si?
        # expect(user.reload.auth_token).to eq(subject)
      end
    end

    context 'when no email is provided' do
      subject do
        described_class.new(password: password)
      end

      let!(:subject_response) { subject.call }

      it 'returns false' do
        expect(subject_response).to be false
      end

      it 'returns EMPTY_EMAIL error with a reader' do
        expect(subject.error).to eq(ApiLoginManager::EMPTY_EMAIL)
      end
    end

    context 'when no password is provided' do
      subject do
        described_class.new(email: user.email)
      end

      let!(:subject_response) { subject.call }

      it 'returns false' do
        expect(subject_response).to be false
      end

      it 'returns EMPTY_PASSWORD error with a reader' do
        expect(subject.error).to eq(ApiLoginManager::EMPTY_PASSWORD)
      end
    end

    context 'when the email is incorrect' do
      subject do
        described_class.new(email: Faker::Internet.email, password: password)
      end

      let!(:subject_response) { subject.call }

      it 'returns false' do
        expect(subject_response).to be false
      end

      it 'returns USER_NOT_FOUND error with a reader' do
        expect(subject.error).to eq(ApiLoginManager::USER_NOT_FOUND)
      end
    end

    context 'when the password is incorrect' do
      subject do
        described_class.new(email: user.email, password: SecureRandom.uuid)
      end

      let!(:subject_response) { subject.call }

      it 'returns false' do
        expect(subject_response).to be false
      end

      it 'returns WRONG_PASSWORD error with a reader' do
        expect(subject.error).to eq(ApiLoginManager::WRONG_PASSWORD)
      end
    end

    context 'when ExternalValidator conection fails' do
      before do
        allow(ExternalValidator).to receive(:call).and_return(false)
      end

      subject do
        described_class.new(email: user.email, password: password)
      end

      let!(:subject_response) { subject.call }

      it 'returns false' do
        expect(subject_response).to be false
      end

      it 'returns EXTERNAL_VALIDATOR error with a reader' do
        expect(subject.error).to eq(ApiLoginManager::EXTERNAL_VALIDATOR)
      end
    end
  end
end
