# OmniHooks::CoreWarehouse

This gem implements a Core Warehouse Webhook strategy for OmniHooks.

The strategy will accept the HTTP POST message from CoreWarehouse, using the root XML node name as the event type.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omnihooks-core-warehouse'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omnihooks-core-warehouse

## Usage


````ruby
app = Rack::Builder.new do
	use OmniHooks::Builder do
	  provider :core_warehouse do |p|
	  	p.configure do |c|
	  	  c.subscribe 'Shipment', Proc.new { |event| nil }
	  	end
	  end
	end
end

run app
````

The Strategy will expect a query parameter `owner` as part of the HTTP request.

### Sample HTTP Request

`curl -X POST --data '<xml-payload-here>' http://example.com/hooks/core-warehouse?owner=foo%20bar`

### Sample Event Data

````ruby
{
	owner: "foo bar", 
	event: "<?xml version="1.0" encoding="UTF-8"?> <Shipment> <OrderNum>90350837</OrderNum> <ReferenceNum>5196</ReferenceNum> <ShipDate>20170503</ShipDate> <ShipMethod>UP04</ShipMethod> <OrderLines> <OrderLine> <Item>847860038626</Item> <QuantityShipped>1</QuantityShipped> </OrderLine> </OrderLines> <PackageDetails> <PackageDetail> <TrackingNumber>testshipment04281</TrackingNumber> <Weight>6.2</Weight> </PackageDetail> </PackageDetails> </Shipment>"
}
````

See [Omnihooks Usage](https://github.com/dropstream/omnihooks#usage) for additional usage options for subscribing to events.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/omnihooks-core-warehouse.

