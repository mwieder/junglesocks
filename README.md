## junglesocks coding challenge

### There are two ruby versions of the test suite here:
An RSpec version and a Capybara version.
They're necessarily different, and each has advantages and drawbacks.
I find Capybara code easier to read and maintain, but RSpec has some element locators that are easier to use than Capybara's built-in locators, although other locators can be monkey-patched. I didn't go that route, as I think it's beyond the scope of this simple coding challenge.

The test suites can be run from ruby via (assuming the bundler gem is installed)
* cd tests
* bundle exec rspec junglesocks.rb
* bundle exec rspec earnest.rb

The result of the test suites is that North Dakota's tax rate is 10% when it should be 5%.

With the obvious out of the way, I have several comments on the two web pages:

The Confirmation page says "Confirm your order" but there's no way to confirm it or move on.

Notice that 'quantity' is spelled wrong on the page
(and on the code test instructions)

Input amounts are not being sanitized:
* You can order more items than are in stock. This may be ok, with the excess placed on backorder.
* The maximum valid quantity is 99999999999990. Ordering more results in math errors.
* Strings count as zero: trying to order "hello" zebras should flag an error.
* Same with negative amounts.
* Divide-by-zero errors seriously break the app:
* Enter '1/0' for any order amount, and the result is ERR_EMPTY_RESPONSE.
 
Note that manually selecting the initial blank line for state throws a 500 error.

The authenticity token seems to be ignored: changing it doesn't affect the order.

'line_items[][quantity]' is an awkward name for the quantity elements:
* RSpec can locate the element by name
* Capybara can't natively locate by name, but there's an ugly xpath locator for it.
 
The quantity elements can be located by type from Capybara, but only because there are no other input boxes.
A unique id for the enclosing table would alleviate this situation.

The state selector has no unique id:
* Rspec can locate it by name ('commit')
* Capybara can locate it by value ('checkout')
* If there were other forms on the page with submit buttons this might be a problem.

It's possible to get to the order form via http as well as https. While this isn't a problem at the order point, only https should be allowed on an actual ecommerce shopping cart.
