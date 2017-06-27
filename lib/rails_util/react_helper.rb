module RailsUtil
  # `RailsUtil::ReactHelper` contains wrapper methods for rendering React components using the `react_on_rails` gem
  module ReactHelper
    # Helper method for rendering a React component to the DOM
    # A view file named `component.html.erb` containing the `react_component` view helper is also required for this method
    # @example Render a component
    #   # app/controllers/main_controller.rb
    #   class MainController < ApplicationController
    #     def app
    #       render_component 'MainApp', props: {}
    #     end
    #   end
    #
    #   # app/views/application/component.html.erb
    #   <%= react_component component, options %>
    # @param [String] component the name of the React component to render
    # @param [Hash] options any `props` and other options to pass to the React object
    def render_component(component, options = {})
      render 'component', locals: { component: component, options: options }
    end
  end
end