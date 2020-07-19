module Orders
  class Creator
    attr_reader :params, :errors

    def initialize(params)
      @params = params
    end

    def call
      call!

      true
    rescue ActiveRecord::RecordInvalid
      false
    end

    def call!
      ActiveRecord::Base.transaction do
        order.save!
      end
    end

    def errors
      order.errors
    end

    private

    def order
      @order ||= Order.new(params)
    end
  end
end
