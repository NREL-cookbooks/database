require File.join(File.dirname(__FILE__), 'resource_database')
require File.join(File.dirname(__FILE__), 'provider_database_postgresql_tablespace')

class Chef
  class Resource
    class PostgresqlDatabaseTablespace < Chef::Resource::Database

      def initialize(name, run_context=nil)
        super
        @resource_name = :postgresql_database_tablespace
        @provider = Chef::Provider::Database::PostgresqlTablespace
        @tablespace_name = name
        @directory = nil
        @allowed_actions.push(:create, :drop)
      end

      def tablespace_name(arg=nil)
        set_or_return(
          :tablespace_name,
          arg,
          :kind_of => String
        )
      end

      def directory(arg=nil)
        set_or_return(
          :directory,
          arg,
          :kind_of => String
        )
      end
    end
  end
end
