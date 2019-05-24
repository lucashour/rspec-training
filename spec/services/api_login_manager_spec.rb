require 'rails_helper'

# Los skips sirven para prevenir la ejecución del it, así que es necesario
# borrarlos (en su lugar implementen los tests, no sean vagos).

RSpec.describe ApiLoginManager do
  # Idealmente la contraseña del usuario estaría encriptada en la base
  # de datos, por lo que no vamos a poder recuperarla del usuario para
  # utilizarla. Es por eso que conviene usarla desde una variable con
  # let!(:password) { SecureRandom.hex }. Al crear el usuario,
  # en let!(:user) { ... }, usar esta variable.
  EMPTY_EMAIL        = 'El email no puede estar en blanco.'.freeze
  EMPTY_PASSWORD     = 'La contraseña no puede estar en blanco.'.freeze
  USER_NOT_FOUND     = 'El usuario no existe'.freeze
  WRONG_PASSWORD     = 'La contraseña es incorrecta'.freeze
  EXTERNAL_VALIDATOR = 'El usuario ya no tiene cuota disponible'.freeze

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
        # Por dos cosas: primero, un usuario creado sin parámetros recibirá una password
        # generada que nunca sabremos cuál es, por lo que hay que crearlo con una pass
        # conocida (la definida al comienzo del test). Segundo, si no se recarga el
        # registro desde la base de datos, el cambio no se verá reflejado.
        expect { subject }.to change { user.reload.auth_token }
      end

      it 'returns the auth_token' do
        expect(subject).to eq(user.reload.auth_token)
      end
    end

    context 'when no email is provided' do
      subject { described_class.new(password: password) }

      it 'returns false' do
        expect(subject.call).to eq(false)
      end

      it 'returns EMPTY_EMAIL error with a reader' do
        subject.call
        expect(subject.error).to eq(EMPTY_EMAIL)
      end
    end

    context 'when no password is provided' do
      subject { described_class.new(email: user.email) }

      it 'returns false' do
        expect(subject.call).to eq(false)
      end

      it 'returns EMPTY_PASSWORD error with a reader' do
        subject.call
        expect(subject.error).to eq(EMPTY_PASSWORD)
      end
    end

    context 'when the email is incorrect' do
      subject { described_class.new(email: 'wrong@email.com', password: password) }

      it 'returns false' do
        expect(subject.call).to eq(false)
      end

      it 'returns USER_NOT_FOUND error with a reader' do
        subject.call
        expect(subject.error).to eq(USER_NOT_FOUND)
      end
    end

    context 'when the password is incorrect' do
      subject { described_class.new(email: user.email, password: 'wrong_pass') }

      it 'returns false' do
        expect(subject.call).to eq(false)
      end

      it 'returns WRONG_PASSWORD error with a reader' do
        subject.call
        expect(subject.error).to eq(WRONG_PASSWORD)
      end
    end

    # Definir un nuevo context para cuando la conexión
    # con ExternalValidator falla. Acá los quiero ver...

    context 'when ExternalValidator fails' do
      subject { described_class.new(email: user.email, password: password) }

      before do
        allow(ExternalValidator).to receive(:call).and_return(false)
      end

      it 'returns false' do
        expect(subject.call).to eq(false)
      end

      it 'returns WRONG_PASSWORD error with a reader' do
        subject.call
        expect(subject.error).to eq(EXTERNAL_VALIDATOR)
      end
    end
  end
end
