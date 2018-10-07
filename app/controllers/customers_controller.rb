class CustomersController < ApplicationController
  PAGE_SIZE = 10

  def index
    @page = (params[:page] || 0).to_i
    if (@keywords = params[:keywords]).present?
      customer_search_term = CustomerSearchTerm.new @keywords
      @customers = Customer.where(customer_search_term.where_clause,
        customer_search_term.where_args).order(customer_search_term.order)
        .offset(@page * PAGE_SIZE).limit(PAGE_SIZE)
    else
      @customers = []
    end
  end
end
