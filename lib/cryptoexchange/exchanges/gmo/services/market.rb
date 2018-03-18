module Cryptoexchange::Exchanges
  module Gmo
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            true
          end
        end

        def fetch(market_pair)
          output = super(ticker_url)
          adapt(output,market_pair)
        end

        def ticker_url
          "#{Cryptoexchange::Exchanges::Gmo::Market::API_URL}/api/v1/master/getCurrentRate.json"
        end

        def adapt(output,market_pair)
          array = output['data']
          market = array.select{ |a|
            a['productId'] == base_to_product_id(market_pair.base)
          }.first

          ticker           = Cryptoexchange::Models::Ticker.new
          ticker.base      = market_pair.base
          ticker.target    = market_pair.target
          ticker.market    = Gmo::Market::NAME
          ticker.ask       = NumericHelper.to_d(market['ask'])
          ticker.bid       = NumericHelper.to_d(market['bid'])
          ticker.last      = NumericHelper.to_d(market['bid'])
          ticker.high      = NumericHelper.to_d(market['highRate'])
          ticker.low       = NumericHelper.to_d(market['lowRate'])
          ticker.volume    = nil
          ticker.timestamp = Time.parse(market['createDatetime']).to_i
          ticker.payload   = output
          ticker
        end

        def base_to_product_id(base)
          case base.upcase
            when 'BTC'
              return 1001
            when 'ETH'
              return 1002
            when 'BCH'
              return 1003
            when 'LTC'
              return 1004
            when 'XRP'
              return 1005
          end
        end

      end
    end
  end
end
