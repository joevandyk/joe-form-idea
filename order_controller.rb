
# Controller
class OrdersController < ActionController::Base
  before_filter :load_form
  before_filter :cart_good?, :only => :shipping

  def cart
  end

  def shipping
    if @form.no_shipping_errors?
      @form.save!
      redirect_to :action => 'thanks'
    end
  end

  def thanks
    @order = @form.order
  end

  private

  def cart_good?
    if @form.cart_errors?
      redirect_to :action => 'cart'
      return false
    end
  end

  def load_form
    @form = Forms::OrderForm.new(
      :controller => self,
      :attributes => params[:order]
    )
  end
end


