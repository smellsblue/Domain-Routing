module DomainRouting
  module RoutingAdditions
    def with_domain
      constraints DomainRouting::DomainConstraints do
        yield
      end
    end

    def without_domain
      constraints DomainRouting::Negated::DomainConstraints do
        yield
      end
    end

    def with_subdomain
      constraints DomainRouting::SubdomainConstraints do
        yield
      end
    end

    def without_subdomain
      constraints DomainRouting::Negated::SubdomainConstraints do
        yield
      end
    end

    def with_domain_or_subdomain
      constraints DomainRouting::DomainOrSubdomainConstraints do
        yield
      end
    end

    def without_domain_or_subdomain
      constraints DomainRouting::Negated::DomainOrSubdomainConstraints do
        yield
      end
    end

    def with_ssl
      constraints DomainRouting::SSL do
        yield
      end
    end

    def without_ssl
      constraints DomainRouting::Negated::SSL do
        yield
      end
    end

    def secure_redirect(route)
      ssl = redirect do |_, request|
        "https://#{request.host_with_port}#{request.fullpath}"
      end

      if route == :root
        root :to => ssl
      else
        match route, :to => ssl
      end
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

  class SSL
    def self.matches?(request)
      return true if DomainRouting::Config.act_as_ssl
      request.ssl?
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

    class SSL
      def self.matches?(request)
        !DomainRouting::SSL.matches?(request)
      end
    end
  end
end

class ActionDispatch::Routing::Mapper
  include DomainRouting::RoutingAdditions
end
