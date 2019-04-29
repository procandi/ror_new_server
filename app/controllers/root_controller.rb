class RootController < ApplicationController
  def home
  	#get customer
  	@customer=get_customer
  end
  def test
  end
end
