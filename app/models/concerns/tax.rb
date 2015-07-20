module Tax
  extend ActiveSupport::Concern

  included do
    enum tax: [:no, :one, :two]
  end
end
