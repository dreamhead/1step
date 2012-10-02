module PageWithHome
  include Gizmo::PageMixin

  def has_hello_to?(name)
    has_content?("Hello, #{name}")
  end
end