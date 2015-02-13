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
      "Expense Type" => "expense_type",
      "Status" => "status",
      "Conflict" => "conflict"
    }[column]
  end

  def sorted_params(params)
    "direction=#{sorted_direction(params[:direction])}&order=#{sorted_order(params[:order]).downcase}"
  end

  private

  def sorted_direction(direction)
    !params[:direction].blank?  ? params[:direction] : "desc"
  end

  def sorted_order(order)
    !params[:sort].blank? ? params[:sort] : "created_at"
  end
end
