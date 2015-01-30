module ApplicationHelper
  def sortable(column, title = nil)
    new_column = convert(column)
    title ||= column.titleize
    css_class = (new_column == sort_column) ? "current #{sort_direction}" : nil
    direction = (new_column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => new_column, :direction => direction}, {:class => css_class}
  end

  def convert(column)
    {
      "Merchant Name" => "Name",
      "Expense Date" => "Date",
      "created_at" => "created_at",
      "Amount" => "Amount",
      "Remarks" => "Remarks",
      "Expense Type" => "expense_type"
    }[column]
  end
end
