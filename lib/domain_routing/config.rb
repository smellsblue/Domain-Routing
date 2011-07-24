module DomainRouting
  class Config
    class << self
      attr_accessor :main_domains, :invalid_subdomains
    end
  end
end
