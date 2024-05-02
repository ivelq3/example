# frozen_string_literal: true

require 'dry/monads/do'
require 'dry/monads/result'

class DryOperation
  include Dry::Monads::Do
  include Dry::Monads::Result::Mixin
  extend Dry::Initializer

  private

  def validate_contract(contract, params)
    result = contract.new.call(params)
    if result.success?
      Success(result.to_h)
    else
      Failure(result.errors.to_h)
    end
  end
end
