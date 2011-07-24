module DomainRouting
  class Config
    class << self
      def main_domains
        @main_domains || []
      end

      def invalid_subdomains
        @invalid_subdomains || []
      end

      def main_domains=(*values)
        @main_domains = values
      end

      def invalid_subdomains=(*values)
        @invalid_subdomains = values
      end
    end
  end
end
