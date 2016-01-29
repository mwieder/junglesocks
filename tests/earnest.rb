require 'selenium-webdriver'
require 'rspec'
require 'pry'
require_relative '../rspec_socks.rb'

# the RSpec version of the junglesocks test

RSpec.describe 'JungleSocks' do

	include RSpec::Expectations
  include Socks

  before(:all) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://jungle-socks.herokuapp.com"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
	end

  after(:all) do
		@driver.quit
  end

  context 'Catalog' do
		it "passes if it lands on the jungle_socks page" do
			# go_to_jungle_socks
		  @driver.get(@base_url)
		  validate_order_page
		end
	end
	
	context 'Orders' do
		describe 'iterates through states' do
		  it 'validates a state tax rate' do
		  	@states = states_list
		  	@states.each do |state|
	  			validate_state state
	  		end
		  end
		end
  end

end

