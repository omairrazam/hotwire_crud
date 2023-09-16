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
class HotwireCrudGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :actions, type: :array, default: %w[index edit new show]

  def create_static_controller_file
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
end
