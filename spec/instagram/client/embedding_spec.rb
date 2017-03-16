require File.expand_path('../../../spec_helper', __FILE__)

describe Instagram::Client do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :client_secret => 'CS', :access_token => 'AT')
      end

      describe ".oembed" do
        before do
          stub_request(:get, "https://api.instagram.com/oembed/?access_token=AT&url=http://instagram.com/p/abcdef").
          with(:headers => {'Accept'=>'application/json; charset=utf-8', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Token token="AT"', 'User-Agent'=>'Instagram Ruby Gem 1.1.6'}).

          #stub_get_with_overridden_endpoint("https://api.instagram.com/", "oembed").
            #with(:query => {:access_token => @client.access_token, :url => "http://instagram.com/p/abcdef"}).
          to_return(:body => fixture("oembed.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          pending
          @client.oembed("http://instagram.com/p/abcdef")
          a_get("oembed?access_token=AT&url=http://instagram.com/p/abcdef").
            should have_been_made
        end

        it "should return the oembed information for an instagram media url" do
          oembed = @client.oembed("http://instagram.com/p/abcdef")
          oembed.media_id.should == "123657555223544123_41812344"
        end

        it "should return nil if a URL is not provided" do
          oembed = @client.oembed
          oembed.should be_nil
        end
      end
    end
  end
end
