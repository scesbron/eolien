# frozen_string_literal: true

class PasswordsController < Devise::PasswordsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render_resource(resource)
  end

  def respond_to_on_destroy
    head :no_content
  end
end
