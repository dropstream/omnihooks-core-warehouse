require "spec_helper"

def make_env(path = '/hooks/core-warehouse', props = {})
  {
    'REQUEST_METHOD' => 'POST',
    'QUERY_STRING' => 'owner=foo%20bar',
    'PATH_INFO' => path,
    'rack.session' => {},
    'rack.input' => StringIO.new('test=true'),
  }.merge(props)
end

def fixture(file_name)
  data = File.open(File.expand_path("../../../fixtures/#{file_name}.xml", __FILE__)).read
  length = data.bytesize

  { 
    "CONTENT_TYPE" => 'application/xml',
    "CONTENT_LENGTH" => length.to_s,
    'rack.input' => StringIO.new(data) 
  }
end

RSpec.describe OmniHooks::Strategies::CoreWarehouse do

  let(:app) do
    lambda { |_env| [404, {}, ['Awesome']] }
  end

  describe '#options' do
    subject { OmniHooks::Strategies::CoreWarehouse.new(nil) }

    it 'should have a name defined' do
      expect(subject.options.name).to eq('core-warehouse')
    end
  end

  describe '#args' do
    it 'has expected arguments' do
      expect(OmniHooks::Strategies::CoreWarehouse.args).to eq([])
    end
  end

  describe '#call' do
    let(:subscriber) { Proc.new { |s| s } }
    let(:strategy) { OmniHooks::Strategies::CoreWarehouse.new(app) }

    before(:each) do
      OmniHooks::Strategies::CoreWarehouse.configure do |events|
        events.subscribe('Shipment', subscriber)
      end
    end

    context 'with a matched event' do
      it 'should pass the event to the subscriber' do
        expect(subscriber).to receive(:call).with({owner: "foo bar", event: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Shipment>\n   <OrderNum>90350837</OrderNum>\n   <ReferenceNum>5196</ReferenceNum>\n   <ShipDate>20170503</ShipDate>\n   <ShipMethod>UP04</ShipMethod>\n   <OrderLines>\n      <OrderLine>\n         <Item>847860038626</Item>\n         <QuantityShipped>1</QuantityShipped>\n      </OrderLine>\n   </OrderLines>\n   <PackageDetails>\n      <PackageDetail>\n         <TrackingNumber>testshipment04281</TrackingNumber>\n         <Weight>6.2</Weight>\n      </PackageDetail>\n   </PackageDetails>\n</Shipment>"})

        strategy.call(make_env('/hooks/core-warehouse', fixture('single_line_item_single_tracking_number')))
      end

      context 'with missing owner query parameter' do
        it 'should not pass event' do
          expect(subscriber).not_to receive(:call)

          strategy.call(make_env('/hooks/core-warehouse', fixture('single_line_item_single_tracking_number').merge('QUERY_STRING' => '')))
        end
      end
    end

    context 'with an unmatched event' do
      it 'should pass the event to the subscriber' do
        expect(subscriber).not_to receive(:call)

        strategy.call(make_env('/hooks/core-warehouse', fixture('unmatching_event')))
      end
    end       
  end
end
