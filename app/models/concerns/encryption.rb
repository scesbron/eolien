module Encryption

  extend ActiveSupport::Concern

  module ClassMethods
    def encryption_key
      ENV['ENCRYPT_KEY']
    end
  end

end
