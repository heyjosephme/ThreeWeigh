# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # Rate limit password reset requests by email (prevents spam/enumeration)
  # Allows 3 password reset requests per email within 1 hour
  rate_limit to: 3, within: 1.hour, only: :create,
             by: -> { request.params.dig('user', 'email')&.downcase&.presence }

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
