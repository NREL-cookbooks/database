require File.join(File.dirname(__FILE__), 'resource_database')
require File.join(File.dirname(__FILE__), 'provider_database_postgresql_role')

class Chef
  class Resource
    class PostgresqlDatabaseRole < Chef::Resource::Database

      def initialize(name, run_context=nil)
        super
        @resource_name = :postgresql_database_role
        @provider = Chef::Provider::Database::PostgresqlRole
        @role_name = name
        @allowed_actions.push(:create, :drop)
      end

      def role_name(arg=nil)
        set_or_return(
          :role_name,
          arg,
          :kind_of => String
        )
      end
    end
  end
end
