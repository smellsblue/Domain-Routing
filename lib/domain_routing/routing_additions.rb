module DomainRouting
  module RoutingAdditions
    def with_domain(&block)
      constraints DomainRouting::DomainConstraints, &block
    end

    def without_domain(&block)
      constraints DomainRouting::Negated::DomainConstraints, &block
    end

    def with_subdomain(&block)
      constraints DomainRouting::SubdomainConstraints, &block
    end

    def without_subdomain(&block)
      constraints DomainRouting::Negated::SubdomainConstraints, &block
    end

    def with_domain_or_subdomain(&block)
      constraints DomainRouting::DomainOrSubdomainConstraints, &block
    end

    def without_domain_or_subdomain(&block)
      constraints DomainRouting::Negated::DomainOrSubdomainConstraints, &block
    end
  end

  class DomainConstraints
    def self.matches?(request)
      DomainRouting::Util.domain_for(request).present?
    end
  end

  class SubdomainConstraints
    def self.matches?(request)
      DomainRouting::Util.subdomain_for(request).present?
    end
  end

  class DomainOrSubdomainConstraints
    def self.matches?(request)
      DomainRouting::DomainConstraints.matches?(request) || DomainRouting::SubdomainConstraints.matches?(request)
    end
  end

  module Negated
    class DomainConstraints
      def self.matches?(request)
        !DomainRouting::DomainConstraints.matches?(request)
      end
    end

    class SubdomainConstraints
      def self.matches?(request)
        !DomainRouting::SubdomainConstraints.matches?(request)
      end
    end

    class DomainOrSubdomainConstraints
      def self.matches?(request)
        !DomainRouting::DomainOrSubdomainConstraints.matches?(request)
      end
    end
  end
end

class ActionDispatch::Routing::Mapper
  include DomainRouting::RoutingAdditions
end
