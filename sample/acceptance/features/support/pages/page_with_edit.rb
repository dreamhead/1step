module PageWithEdit
  include Gizmo::PageMixin
  def create_with data
    data.each do |key, value|
      page.fill_in key, :with => value
    end
    submit_button.click
  end

  def submit_button
    page.find("input[type='submit']")
  end
end
