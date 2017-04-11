module RailsUtil
  module ReactHelper
    def render_component(component, options = {})
      render 'component', locals: { component: component, options: options }
    end
  end
end