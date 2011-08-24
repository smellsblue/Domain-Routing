module DomainRouting
  class Config
    class << self
      attr_accessor :act_as_ssl

      def main_domains
        @main_domains || []
      end

      def invalid_subdomains
        @invalid_subdomains || []
      end

      def main_domains=(*values)
        @main_domains = values.flatten.map(&:downcase)
      end

      def invalid_subdomains=(*values)
        @invalid_subdomains = values.flatten.map(&:downcase)
      end
    end
  end
end
