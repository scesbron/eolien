# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers

  def render_resource(resource)
    if resource.respond_to?(:errors) && resource.errors.any?
      validation_error(resource)
    else
      render json: resource
    end
  end

  def validation_error(resource)
    render json: {
      errors: resource.errors.to_a
    }, status: :bad_request
  end

  def frontend_index_html
    render file: 'public/index.html'
  end
end
