class Order
  require_relative './menu'
  require 'twilio-ruby'

  def initialize
    @order_list = []
  end

  def add_items(menu_item)
    menu_item_references.each do |cocktail,price|
      # use if you make the order_list as a hash
      # @order_list[cocktail] = price.to_i if menu_item == cocktail 
      @order_list << {cocktail: cocktail, price: price.to_i} if menu_item == cocktail
    end
    @order_list
  end

  def display_order_and_query_for_more
    str = self.display_header
    str+= "\n#{self.display_to_s}"
    str+= "\n#{self.display_total}"
    str+= "\nWould you like anything else?"
    str+= "\nPress enter if you are done."
  end

  def drink_count
    @order_list.count
  end

  def menu_item_references
    a = Menu.new
    a.menu_reference
  end

  def calculate_cost
    @order_list.inject(0) do |total, order|
      total += order[:price]
    end
  end

  def display_to_s
    str = ""
    @order_list.each do |order|
      str+= "\n"
      str+= "#{order[:cocktail]} ..... £ #{order[:price]}"
    end
    str
  end

  def display_header
    str = "----------Your Order----------"
    str += "\n"
    str += "------------------------------"
    str
  end

  def display_total
    total = self.calculate_cost
    str = ""
    str += "\n"
    str += "Order Total ..... £ #{total}"
  end

  def create_sms
    header = self.display_header 
    body = self.display_to_s
    footer = self.display_total
    message = "#{header} #{body} #{footer}"
  end

  def send_sms
    message = create_sms
   # test credentials 
    account_sid = 'AC4a3c76c6e67101b36fffdfa4b39f8abd' 
    auth_token = '5359b597fcac47d939480e5cf7ddd9d4' 
  # set up a client to talk to the Twilio REST API 
    @client = Twilio::REST::Client.new account_sid, auth_token 
    @client.account.messages.create({
    :from => '+441262722027', 
    :to => '+447753192332', 
    :body => "#{message}"
    })
  end
end