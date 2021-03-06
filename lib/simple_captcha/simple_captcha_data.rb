module SimpleCaptcha
  class SimpleCaptchaData < ::ActiveRecord::Base

    attr_accessible :key, :value

    self.table_name = "simple_captcha_data"

    class << self
      def get_data(key)
        data = where(key: key).first || new(key: key)
      end
      
      def remove_data(key)
        delete_all(["#{connection.quote_column_name(:key)} = ?", key])
        clear_old_data(1.hour.ago)
      end
      
      def clear_old_data(time = 1.hour.ago)
        return unless Time === time
        delete_all(["#{connection.quote_column_name(:updated_at)} < ?", time])
      end
    end
  end
end
