module PageWithList
  include Gizmo::PageMixin

  def records_attrs
    page.all(".record").map{|record| {"name" => record.find(".name").text, "data" => record.find(".name").text}}
  end
end
