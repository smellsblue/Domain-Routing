# Summary

DomainRouting is a gem for Rails 3 that provides some convenient
helpers for routing with multiple domains and subdomains.

# Install

Just add the following to your Gemfile and bundle:

    gem "domain_routing"

# Configuration

You will want to mark what subdomains don't count in your
config/application.rb:

    DomainRouting::Config.invalid_subdomains = "www"

In your various environments, you will want to specify what domains
are your main domains:

config/environments/development.rb:

    DomainRouting::Config.main_domains = "lvh.me"

config/environments/production.rb:

    DomainRouting::Config.main_domains = "mysite.com"

config/environments/test.rb:

    DomainRouting::Config.main_domains = "example.org", "example.com", "test.host"

# Usage

You can then route using the routing helpers.  Note that a subdomain
is only the last subdomain returned from request.subdomains, if any
exist.

    with_domain do
      # Add routes that will trigger with a domain not specified as a
      # "main_domain"
    end

    without_domain do
      # Add routes that will trigger with a domain specified as a
      # "main_domain"
    end

    with_subdomain do
      # Add routes that will trigger with a subdomain other than one
      # specified in "invalid_subdomains"
    end

    without_subdomain do
      # Add routes that will trigger without a subdomain or with a
      # subdomain specified in "invalid_subdomains"
    end

    with_domain_or_subdomain do
      # Add routes that will trigger when with_domain would trigger or
      # with_subdomain would trigger
    end

    without_domain_or_subdomain do
      # Add routes that will trigger when with_domain and
      # with_subdomain would not trigger
    end

You can also retrieve the domain or subdomain that the routing methods
will use to determine if a domain or subdomain is present:

    # Returns the domain from the request, but only if it isn't
    # specified in "main_domains".  Otherwise returns "".
    DomainRouting::Util.domain_for(request)

    # Returns the last subdomain from the request, but only if it
    # isn't specified in "invalid_subdomains".  Otherwise returns "".
    DomainRouting::Util.subdomain_for(request)
