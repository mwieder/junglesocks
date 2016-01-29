require 'selenium-webdriver'
require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'pry'
require_relative '../socks.rb'

# the Capybara version of the junglesocks test

RSpec.describe 'JungleSocks' do

	include RSpec::Expectations
	include Capybara::DSL
  include Socks

  before(:all) do
    @base_url = "https://jungle-socks.herokuapp.com"
		Capybara.default_driver = :selenium
		Capybara.run_server = false
	end

  after(:all) do
#		@driver.quit
  end

  context 'Catalog' do
		it "passes if it lands on the jungle_socks page" do
			# go_to_jungle_socks
		  visit(@base_url)
		  validate_order_page
		end
	end
	
	context 'Orders' do
		describe 'iterates through states' do
#			before do
#		  	@states = states_list
#			end
		  it 'validates a state tax rate' do
		  	@states = states_list
		  	@states.each do |state|
	  			validate_state state
	  		end
		  end
		end
  end

end

