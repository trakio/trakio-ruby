require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '.page_view' do

    context 'when a url is specified' do
      context 'when a title is specified' do
        it 'tracks a page_view' do
          stub = stub_request(:post, "https://api.trak.io/v1/track").
            with(:body => {
              token: 'my_api_token',
              data: {
                time: /.+/,
                distinct_id: 'user@example.com',
                event: 'Page view',
                properties: {
                  title: 'Test Title',
                  url: 'http://test.test/test',
                }
              }
            }).to_return(:body => {
              status: 'success',
              trak_id: '1234567890'
            }.to_json)

          trakio = Trakio.new 'my_api_token'
          resp = trakio.page_view distinct_id: 'user@example.com', title: 'Test Title', url: 'http://test.test/test'

          expect(resp[:status]).to eql 'success'
          expect(resp[:trak_id]).to eql '1234567890'

          stub.should have_been_requested
        end
      end

      context 'when a title is not specified' do
        it 'should raise an error' do
          trakio = Trakio.new 'my_api_token'
          expect {
            trakio.page_view distinct_id: 'user@example.com',
              url: 'http://test.test/test'
          }.to raise_error RuntimeError
        end
      end
    end

    context 'when a url is not specified' do
      it 'should raise an error' do
        trakio = Trakio.new 'my_api_token'
        expect {
          trakio.page_view distinct_id: 'user@example.com'
        }.to raise_error RuntimeError
      end

      context 'when a title is specified' do
        it 'should raise an error' do
          trakio = Trakio.new 'my_api_token'
          expect {
            trakio.page_view distinct_id: 'user@example.com', title: 'Test Title'
          }.to raise_error RuntimeError
        end
      end
    end

  end  # end .page_view

end
