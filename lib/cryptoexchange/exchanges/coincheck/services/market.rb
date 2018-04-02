module Cryptoexchange::Exchanges
  module Coincheck
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            true
          end
        end

        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output,market_pair)
        end

        def ticker_url(market_pair)
          "#{Cryptoexchange::Exchanges::Coincheck::Market::API_URL}/rate/#{market_pair.base}_#{market_pair.target}"
        end

        def adapt(output,market_pair)
          ticker           = Cryptoexchange::Models::Ticker.new
          ticker.base      = market_pair.base
          ticker.target    = market_pair.target
          ticker.market    = Coincheck::Market::NAME
          # ticker.ask       = NumericHelper.to_d(output['ask'])
          # ticker.bid       = NumericHelper.to_d(output['bid'])
          # ticker.last      = NumericHelper.to_d(output['last'])
          # ticker.high      = NumericHelper.to_d(output['high'])
          # ticker.low       = NumericHelper.to_d(output['low'])
          # ticker.volume    = NumericHelper.to_d(output['volume'])
          # ticker.timestamp = output['timestamp'].to_i
          ticker.last      = NumericHelper.to_d(output['rate'])
          ticker.timestamp = Time.now.to_i
          ticker.payload   = output
          ticker
        end
      end
    end
  end
end
