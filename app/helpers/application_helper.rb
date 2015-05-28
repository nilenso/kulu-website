module ApplicationHelper
  def sortable(column, title = nil)
    new_column = convert(column)
    title ||= column.titleize
    css_class = (new_column == sort_column) ? "current #{sort_direction}" : nil
    direction = (new_column == sort_column && sort_direction == 'asc') ? 'desc' : 'asc'

    link_to title, {:order => new_column, :direction => direction,
                    :page => params[:page] || 1, :per_page => params[:per_page] || 15}, {:class => css_class}
  end

  def convert(column)
    {
        'Merchant Name' => 'name',
        'Expense Date' => 'date',
        'created_at' => 'created_at',
        'Amount' => 'amount',
        'Remarks' => 'remarks',
        'Expense Type' => 'expense_type',
        'Status' => 'status',
        'Conflict' => 'conflict'
    }[column]
  end

  def sorted_params
    "direction=#{sorted_direction}&order=#{sorted_order.downcase}"
  end

  private

  def sorted_direction
    !params[:direction].blank? ? params[:direction] : 'desc'
  end

  def sorted_order
    !params[:order].blank? ? params[:order] : 'created_at'
  end
end
