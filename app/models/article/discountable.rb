module Article::Discountable
  extend ActiveSupport::Concern

  included do
    before_create :set_discount_id, if: :qualifies_for_discount?

    def qualifies_for_discount?
      Discount.current.count > 0
    end

    def set_discount_id
      self.discount_id = Discount.current.last.id 
    end
  end
end
