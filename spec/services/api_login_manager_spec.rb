require 'rails_helper'

# Los skips sirven para prevenir la ejecución del it, así que es necesario
# borrarlos (en su lugar implementen los tests, no sean vagos).

RSpec.describe ApiLoginManager do
  # Idealmente la contraseña del usuario estaría encriptada en la base
  # de datos, por lo que no vamos a poder recuperarla del usuario para
  # utilizarla. Es por eso que conviene usarla desde una variable con
  # let!(:password) { SecureRandom.hex }. Al crear el usuario,
  # en let!(:user) { ... }, usar esta variable.
  let!(:password) { SecureRandom.hex }

  let!(:user) { FactoryBot.create(:user, password: password) } # -- crear usuario con FactoryBot -- #

  describe '#call' do
    context 'when user provided data is valid' do
      before do
        # Realizar un stub del ExternalValidator para que se ejecuta realmente
        allow(ExternalValidator).to receive(:call).and_return(true)
      end

      subject do
        described_class.new(email: user.email, password: password).call
      end

      it "update user's auth_token" do
        # skip 'Una vez que definan a user, este test va a fallar. ¿Por qué?'
        expect { subject }.to change { user.reload.auth_token }
      end

      it 'returns the auth_token' do
        expect(subject).to eq(user.reload.auth_token)
      end
    end

    context 'when no email is provided' do
      subject do
        described_class.new(password: password)
      end

      it 'returns false' do
        expect(subject.call).to be_falsey
      end

      it 'returns EMPTY_EMAIL error with a reader' do
        subject.call
        expect(subject.error).to be(ApiLoginManager::EMPTY_EMAIL)
      end
    end

    context 'when no password is provided' do
      subject do
        described_class.new(email: user.email)
      end

      it 'returns false' do
        expect(subject.call).to be_falsey
      end

      it 'returns EMPTY_PASSWORD error with a reader' do
        subject.call
        expect(subject.error).to be(ApiLoginManager::EMPTY_PASSWORD)     
      end
    end

    context 'when the email is incorrect' do
      subject do
        described_class.new(email: 'sarasa@sarasa.com', password: password)
      end
      it 'returns false' do
        expect(subject.call).to be_falsey
      end

      it 'returns USER_NOT_FOUND error with a reader' do
        subject.call
        expect(subject.error).to be(ApiLoginManager::USER_NOT_FOUND)
      end
    end

    context 'when the password is incorrect' do
      subject do
        described_class.new(email: user.email, password: 'trulala')
      end
      it 'returns false' do
        expect(subject.call).to be_falsey
      end

      it 'returns WRONG_PASSWORD error with a reader' do
        subject.call
        expect(subject.error).to be(ApiLoginManager::WRONG_PASSWORD)
      end
    end

    context 'when ExternalValidator fails' do
      before do
        # Realizar un stub del ExternalValidator para que se ejecuta realmente
        allow(ExternalValidator).to receive(:call).and_return(false)
      end

      subject do
        described_class.new(email: user.email, password: password)
      end

      it 'returns false' do
        expect(subject.call).to be_falsey
      end

      it 'returns EXTERNAL_VALIDATOR error with a reader' do
        subject.call
        expect(subject.error).to be(ApiLoginManager::EXTERNAL_VALIDATOR)
      end
    end

    # Definir un nuevo context para cuando la conexión
    # con ExternalValidator falla. Acá los quiero ver...
  end
end
