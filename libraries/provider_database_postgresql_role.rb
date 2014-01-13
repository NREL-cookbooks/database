require File.join(File.dirname(__FILE__), 'provider_database_postgresql')

class Chef
  class Provider
    class Database
      class PostgresqlRole < Chef::Provider::Database::Postgresql
        include Chef::Mixin::ShellOut

        def load_current_resource
          Gem.clear_paths
          require 'pg'
          @current_resource = Chef::Resource::PostgresqlDatabaseRole.new(@new_resource.name)
          @current_resource.role_name(@new_resource.name)
          @current_resource
        end

        def action_create
          unless exists?
            begin
              db("template1").query("CREATE ROLE \"#{@new_resource.role_name}\"")
              @new_resource.updated_by_last_action(true)
            ensure
              close
            end
          end
        end

        def action_drop
          if exists?
            begin
              db("template1").query("DROP ROLE \"#{@new_resource.role_name}\"")
              @new_resource.updated_by_last_action(true)
            ensure
              close
            end
          end
        end

        private
        def exists?
          begin
            exists = db("template1").query("SELECT * FROM pg_roles WHERE rolname='#{@new_resource.role_name}'").num_tuples != 0
          ensure
            close
          end
          exists
        end

      end
    end
  end
end
