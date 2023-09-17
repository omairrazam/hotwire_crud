# frozen_string_literal: true

# A Rails generator that creates a CRUD (Create, Read, Update, Delete) controller
# with Hotwire support.
#
# This generator creates a controller file, view files, and sets up the
# routes for the CRUD operations. It is designed to be used with Hotwire
# for a more interactive and dynamic user interface.
#
# Usage:
#   rails generate hotwire_crud resource_controller_name
#
# Example:
#   rails generate hotwire_crud products
#
# This will generate a Products controller with actions for index, show, new, edit,
# create, update, and destroy, along with corresponding view templates.
#

# lib/generators/hotwire_crud_generator.rb
require 'English'
class HotwireCrudGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :actions, type: :array, default: %w[index edit new show]

  def create_static_controller_file
    file_name_singular = file_name.singularize

    @actions_data_paths = {
      index: "#{file_name}_path",
      new: "new_#{file_name_singular}_path",
      edit: "edit_#{file_name_singular}_path",
      show: "#{file_name_singular}_path"
    }

    template 'static_controller.erb', File.join('app/controllers/static', "#{file_name}_controller.rb")
  end

  def create_static_controller_test
    template 'static_controller_spec.erb', File.join('spec/controllers/static', "#{file_name}_controller_spec.rb")
  end

  def create_controller_file
    template 'controller.erb', File.join('app/controllers', "#{file_name}_controller.rb")
  end

  def create_controller_test
    template 'controller_spec.erb', File.join('spec/controllers', "#{file_name}_controller_spec.rb")
  end

  def create_views
    actions.each do |action|
      template "views/static_#{action}.html.erb", File.join('app/views/static', file_name, "#{action}.html.haml")
      template "views/#{action}.html.erb", File.join('app/views', file_name, "#{action}.html.haml")
    end
  end

  def insert_routes
    route "resources :#{file_name}, only: #{actions.map(&:to_sym).inspect}"

    route_namespace = 'static'
    route "namespace :#{route_namespace} do\n  resources :#{file_name}, only: #{actions.map(&:to_sym).inspect}\nend"
  end

  def generate_constants
    constants_file_path = File.join('app', 'controllers', 'static', 'hotwire_crud_static_constants.rb')

    create_file(constants_file_path) unless File.exist?(constants_file_path)
    file_content = File.read(constants_file_path)

    actions.each do |action|
      const_name = "#{const_prefix}_#{action.upcase}_TURBO_FRAME_TAG_NAME"
      const_value = "#{const_prefix.downcase}_#{action}"
      next if file_content.include?(const_name)

      append_to_file constants_file_path do
        constants_content(const_name, const_value)
      end
    end

    # if File.exist?(constants_file_path)
    load constants_file_path
    # end
  end

  def run_rubocop_with_auto_correct
    rubocop_command = 'bundle exec rubocop -A'

    system(rubocop_command)

    if $CHILD_STATUS.success?
      say('RuboCop auto-corrections applied successfully.', :green)
    else
      say('RuboCop auto-corrections failed.', :red)
    end
  end

  private

  def constants_content(const_name, const_value)
    <<~RUBY
      #{const_name} = '#{const_value}'
    RUBY
  end

  def const_prefix
    file_name.pluralize.upcase
  end
end
