ORDER_PAGE_TEXT = 'Welcome To Jungle Socks!'
CONFIRMATION_PAGE_TEXT = 'Please Confirm Your Order'

# the RSpec version of the junglesocks test

module Socks

	# remove the leading '$' and the embedded commas
	def currency_of string_value
		string_value.slice(1..-1).gsub(/,/,'').to_f
	end
	
	# limit currency to two decimal places
	def currency_limit currency_float
		((currency_float * 100).round / 100.0).to_f
	end
	
	def states_list
		st = @driver.find_element(:name, "state")
		@states = st.text.split("\n")
	end
	
	def state_tax_rate state
  	case state
  		when 'California'
  			tax_rate = 0.08
  		when 'New York'
  			tax_rate = 0.06
  		when 'Minnesota'
  			tax_rate = 0.00
  		else
  			tax_rate = 0.05
  	end
	end
	
	def validate_order_page
  	expect(@driver.page_source).to include(ORDER_PAGE_TEXT)
	end
	
	def validate_confirmation_page
		expect(@driver.page_source).to include(CONFIRMATION_PAGE_TEXT)
	end
	
	# now we're at the confirmation page
	def validate_amounts_for state
		validate_confirmation_page
		
		tax_rate = state_tax_rate(state)
		  	
  	subtotal = @driver.find_element(:id, 'subtotal').text
  	taxes = @driver.find_element(:id, 'taxes').text
  	total = @driver.find_element(:id, 'total').text
  	
  	# check the tax computation
  	unless (currency_of taxes) == currency_limit((tax_rate) * (currency_of subtotal))
  		p state + ' tax rate is incorrect'
  	end
  	
  	# check the math while we're at it
  	expect(currency_of total).to eq (currency_of subtotal) + (currency_of taxes)
	end
	
	def fill_quantities
		# fill in the quantities
		# note that you can order more than are in stock
		# the maximum valid quantity is 99999999999990
		# after that point the math is wrong
		# strings count as zero
		
		# divide-by-zero errors break the app:
		# enter '1/0' for any order amount: result ERR_EMPTY_RESPONSE
		@catalog.each do |line_item|
			line_item.send_keys rand(100).to_s
		end
	end
	
	def validate_state state
  	@driver.navigate().refresh()
  	# make sure we're on the right page
  	validate_order_page
  	
  	# select the state from the option menu
  	# note that selecting the initial blank line throws a 500 error.
  	@driver.find_element(:name, "state").send_keys state

		# this is an awkward name for this element
		@catalog = @driver.all(:name, 'line_items[][quantity]')
		
		fill_quantities

  	@driver.find_element(:name, "commit").click
  	
  	# also notice that 'quantity' is spelled wrong on the page
  	# (and on the code test instructions)
  	
  	# the authenticity_token seems to be ignored.
  	
  	validate_amounts_for state
  	@driver.get(@base_url)
	end
	
end

