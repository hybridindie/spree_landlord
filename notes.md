## todo

* ability to see which users are super admin
* write tests for default scopes
* move multi tenant decoration code into a module
* ensure that tenant ids are not overwritten because of using before_validation

## done

* map shortname subdomains to tenant
* figure out way to acceptance test shortname subdomains
* ensure tenant shortnames are stored lower case
* figure out how to test alternative domains
* map fulldomain to tenantname
* ignore tenant subdomains on tenant fulldomain
* ability to create a store without a domain set yet
* ensure that preferences respect tenancy
* ensure that current_tenant_id never returns nil
* figure out how to speed up the tests by removing the call to reset preferences
* refactor calls to `Thread.current[:tenant_id]`
* fix issues with the move existing to master tenant migration
  * work with unscoped instances
  * use update_column for faster speed
* silence bundler warning about authors not being filled out

## won't do

* nil subdomain should load master tenant instead of throwing
