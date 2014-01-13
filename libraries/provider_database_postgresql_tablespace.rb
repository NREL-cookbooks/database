require File.join(File.dirname(__FILE__), 'provider_database_postgresql')

class Chef
  class Provider
    class Database
      class PostgresqlTablespace < Chef::Provider::Database::Postgresql
        include Chef::Mixin::ShellOut

        def load_current_resource
          Gem.clear_paths
          require 'pg'
          @current_resource = Chef::Resource::PostgresqlDatabaseTablespace.new(@new_resource.name)
          @current_resource.tablespace_name(@new_resource.name)
          @current_resource
        end

        def action_create
          unless exists?
            directory(@new_resource.directory) do
              recursive true
              owner "postgres"
              group "postgres"
              mode 0700
            end

            begin
              create_sql = "CREATE TABLESPACE \"#{@new_resource.tablespace_name}\""
              create_sql += " OWNER \"#{@new_resource.owner}\"" if @new_resource.owner
              create_sql += " LOCATION '#{@new_resource.directory}'"
              db("template1").query(create_sql)
              @new_resource.updated_by_last_action(true)
            ensure
              close
            end
          end
        end

        def action_drop
          if exists?
            begin
              db("template1").query("DROP TABLESPACE \"#{@new_resource.tablespace_name}\"")
              @new_resource.updated_by_last_action(true)
            ensure
              close
            end
          end
        end

        private
        def exists?
          begin
            exists = db("template1").query("SELECT * FROM pg_tablespace WHERE spcname='#{@new_resource.tablespace_name}'").num_tuples != 0
          ensure
            close
          end
          exists
        end

      end
    end
  end
end
