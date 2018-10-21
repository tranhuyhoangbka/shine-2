class CustomersController < ApplicationController
  PAGE_SIZE = 10

  def ng
    @base_url = "/customers/ng"
  end

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
    respond_to do |format|
      format.html {
        redirect_to "/customers/ng"
      }
      format.json {render json: {customers: @customers}}
    end
  end

  def show
    customer_detail = CustomerDetail.find params[:id]
    respond_to do |format|
      format.json do
        render json: {customer: customer_detail}
      end
    end
  end
end
