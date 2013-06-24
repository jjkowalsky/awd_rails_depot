class StoreController < ApplicationController
  def index
    @products = Product.all
    # @page_title = "Page Title"
  end
end
