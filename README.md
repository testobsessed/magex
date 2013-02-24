[![Build Status](https://travis-ci.org/testobsessed/magex.png)](https://travis-ci.org/testobsessed/magex)

MAGEX: The Magical Commodity Exchange Server
=====

Magex is a trading platform to support programming competitions and classroom exercises. You can use this code base to run your own magical commodity exchange, or you can write a client to participate in our hosted exchange (site to be determined).

You participate in the exchange by writing a client program against the Magex API to place your buy and sell orders for the commodities listed on the exchange (e.g. wishing wands and flying carpets).

There is no user interface; all interaction with the system is made through HTTP requests. You can write clients for the system in any programming language that supports GET and POST requests. (If you choose to write your client in Ruby, check out the sample client code included in this repository.) 

The rules of trading are simple:

- When you register a new player you automatically have 1000 gold pieces added to your account.
- You can place a buy or sell order at any time.
- Magex automatically matches buy and sell orders based on price. Given equivalent sell or buy offers, Magex matches the earliest first.
- Magex does not check your account balance until it has a possible match. This means you can place an offer to buy even if you do not have sufficient gold or an offer to sell even if you do not have a sufficient quantity of the commodity in question.
- Magex may split a buy or sell order if it can partially complete the transaction. For example, if you place an order to buy 100 wishing wands for 5 gold each, and there is an offer to sell 50 wishing wands at 5 gold, Magex will purchase the 50 wishing wands on your behalf, creating a new order for the remaining 50.

Valuation of commodities is based on actual trades. Until a trade is complete, the valuation of any commodity is returned as -1. Once there are trades, valuation is calculated as a rolling average using the sell price of up to the last 5 trades. So, for example, if Wishing Wands had traded twice so far, once with 10 wands at 5 gold each, and then with 20 wands at 2 wands each, the average would be calculated as follows:

    ((10 * 5) + (20 * 2)) / 30 = (90 gold)/(30 wands) = 3 gold per wand
    
So the market valuation of wands would be set at 3 gold. Market valuations are rounded to the nearest gold. So if the market valuation is calculated at 2.7 gold it will still be reported as 3 gold.

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

All trades are made in gold pieces (whole gold pieces only; no fractions). Magex matches buy and sell orders to complete transactions. It also tracks market valuation for commodities traded on the market.

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

