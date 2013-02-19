magex: The Magical Commodity Exchange Server
=====

Magex is a trading platform to support programming competitions and classroom exercises. You can use this code base to run your own magical commodity exchange, or you can write a client to participate in our hosted exchange (site to be determined).  

You participate in the exchange by writing a client program against the Magex API to place your buy and sell orders for the commodities listed on the exchange (e.g. wishing wands and flying carpets).

All trades are made in gold pieces. Magex matches buy and sell orders to complete transactions. It also tracks market valuation for commodities traded on the market.

The rules of trading are simple:

- When you register a new player you automatically have 1000 gold pieces added to your account.
- You can place a buy or sell order at any time.
- Magex automatically matches buy and sell orders based on price. Given equivalent sell or buy offers, Magex matches the earliest first.
- Magex does not check your account balance until it has a possible match. This means you can place an offer to buy even if you do not have sufficient gold or an offer to sell even if you do not have a sufficient quantity of the commodity in question.
- Magex may split a buy or sell order if it can partially complete the transaction. For example, if you place an order to buy 100 wishing wands for 5 gold each, and there is an offer to sell 50 wishing wands at 5 gold, Magex will purchase the 50 wishing wands on your behalf, creating a new order for the remaining 50.

# Running the Server

Magex is written in Ruby using Sinatra. To get started experimenting on your local development machine:

    git clone https://github.com/testobsessed/magex.git
    bundle install
    rackup

I intend to host a persistent instance of Magex somewhere as a publicly accessible sandbox, but have not yet deployed it. I will update this file when I do.

# Using the Magex API

## Registering

In order to submit orders, you need an account on your Magex server. Getting an account is trivial: you just need to post a request to /account/register with a json payload that specifies your username. For an example, see the sample script create_and_retrieve_account.rb in the client_sample_code folder.

When you create your account, the server hands you back a token named "secret." This is the only authentication mechanism in this system. If you want to make sure none of the other players can make trades using your account, keep your secret secret.

## Buying and Selling

Once you have your account secret, you can use it to make trades by placing buy and sell orders on the exchange.

The commodities listed on the exchange are:

- Wishing Wands (wish)
- Flying Carpets (flyc)
- Singing Swords (sisw)
- Magic Beans (mbns)
- Pixie Dust Vials (pixd)

The API for buying and selling is nearly identical. The only difference is the URL you address your POST command to (/orders/buy or /orders/sell). See the place_order.rb sample in client_sample_code for an example.

## Querying Your Account

## Querying Orders and Transactions

### get /orders/buy
### get /orders/sell
### get /orders/transactions

## Querying Market Data

### /commodities/list

Returns a list of commodities, e.g.:

  { "commodities" : ["wish", "mbns", "sisw", "flyc", "pixd"] }
  
### /commodities/last_traded_prices

Returns 0 if the commodity has never traded before.

### /commodities/average_transaction_prices/:number_of_transactions

### /commodities/average_buy_order_prices/:number_of_orders

### /commodities/average_sell_order_prices/:number_of_orders

## Error Codes

# Client Strategies

# Known Limitations

Note that because this code base is intended for exercises only, it has only cursory security and no data persistence. That means if the server goes down, you will have to restart the simulation from the beginning.

# To Do List

As currently implemented, this project is a little over half done. Work remaining to do:
- Implement the transactions logic
- Implement the market commodity valuation and query logic
- Experiment to determine if the starting amount of gold for a new account should be dependent on current market valuations instead of a fixed amount
- Finish the samples
- Put timestamps on orders and transactions
- Log all activity to one or more files that can be downloaded from a server, e.g. activity CSV, for analysis purposes - valuations, spikes, etc.

# License

The Magex code base and all related artifacts are copyrighted materials licensed under the BSD 2-clause license. See LICENSE.txt for details.

