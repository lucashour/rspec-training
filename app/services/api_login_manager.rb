# frozen_string_literal: true

class ApiLoginError < StandardError; end

class ApiLoginManager
  ERRORS = [
    USER_NOT_FOUND     = 'El usuario no existe',
    EMPTY_EMAIL        = 'El email no puede estar en blanco',
    EMPTY_PASSWORD     = 'La contraseña no puede estar en blanco',
    WRONG_PASSWORD     = 'La contraseña es incorrecta',
    EXTERNAL_VALIDATOR = 'El usuario ya no tiene cuota disponible'
  ].freeze

  attr_reader :error

  def initialize(params)
    @params = params
  end

  def call
    validate_params!
    validate_user!
    validate_password!
    validate_with_external_validator!

    @user.auth_token = SecureRandom.hex
    @user.save!

    @user.auth_token
  rescue ActiveRecord::RecordInvalid, ApiLoginError => error
    @error = error.message
    false
  end

  private

  def validate_params!
    if @params[:email].blank?
      raise ApiLoginError.new(EMPTY_EMAIL)
    end

    if @params[:password].blank?
      raise ApiLoginError.new(EMPTY_PASSWORD)
    end
  end

  def validate_user!
    return if user
    raise ApiLoginError.new(USER_NOT_FOUND)
  end

  def validate_password!
    return if user.valid_password?(@params[:password])
    raise ApiLoginError.new(WRONG_PASSWORD)
  end

  def validate_with_external_validator!
    return if ExternalValidator.call(@params[:email])
    raise ApiLoginError.new(EXTERNAL_VALIDATOR)
  end

  def user
    @user ||= User.find_by(email: @params[:email])
  end
end
