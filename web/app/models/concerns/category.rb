module Category
  extend ActiveSupport::Concern

  included do
    enum category: [:pocketbook, :car, :family]
    validates_presence_of :category
  end
end
