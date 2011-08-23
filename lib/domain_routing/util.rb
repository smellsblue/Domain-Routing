module DomainRouting
  class Util
    class << self
      def domain_for(request)
        domain = request.domain.downcase
        return "" if DomainRouting::Config.main_domains.include?(domain)
        domain
      end

      def subdomain_for(request)
        return "" unless request.subdomains.present?
        subdomain = request.subdomains.last.downcase
        return "" if DomainRouting::Config.invalid_subdomains.include?(subdomain)
        subdomain
      end
    end
  end
end
