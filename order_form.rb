# Form presentation class
class Forms::OrderForm
  include Joe::Rocks::FormStuff
  form_attributes :name, :email, :address, :city, :state, :zip

  # This stores the form stuff in a cookie named order_cookie
  form_storage :cookie, :name => 'order_cookie'

  # This allows you to customize the form storing.
  # Half-baked idea.
  # i.e. you want to save the incomplete forms in a database table
  # or redis or a session or something.
  # You'd create the OrderFormSaver class and override the
  # load and save methods (maybe?).
  form_storage OrderFormSaver

  # These methods get called after the values submitted with the
  # form are merged with the cookie.  Gives you a chance to
  # create objects based off the form values.
  after_load :initialize_order_preview

  # validation_scope is from https://github.com/dasil003/validation_scopes
  # I've got a modified version for Rails 3.
  validation_scope :cart_errors do |scope|
    scope.validates :name,  :presence => true
    scope.validates :email, :email    => true
  end

  validation_scope :shipping_errors do |scope|
    %w( address city state zip ).each do |attr|
      scope.validates attr, :presence => true
    end
  end

  def total
    @order.total
  end

  def save!
    order = Order.new :name          => attributes[:name],
                      :email_address => attributes[:email]

    address = Address.new :address => attributes[:address],
                          :city    => attributes[:city],
                          :state   => attributes[:state],
                          :zip     => attributes[:zip]

    order.address = address

    # Question: how to handle validation problems here?
    # Raise exception and catch in controller?
    order.save
  end

  private


  def initialize_order_preview
    @order = Order.new :user => @controller.current_user,
                       :email_address => attributes[:email]
  end

end
