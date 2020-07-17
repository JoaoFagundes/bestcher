module Reports
  module Orders
    class Financier
      attr_reader :group_type

      def initialize(group_type: :reference)
        @group_type = group_type
      end

      def call
        grouped_orders.map do |group, orders|
          {
            group_type => group,
            :order_count => orders.size,
            :total_value => orders.sum(&:total_value)
          }
        end
      end

      private

      def grouped_orders
        @grouped_orders ||= Order.all.group_by(&group_type)
      end
    end
  end
end
