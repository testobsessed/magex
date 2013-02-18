magex: The Magical Commodity Exchange Server
=====

Magex is a trading platform to support programming competitions and classroom exercises. You can use this code base to run your own magical commodity exchange, or you can write a client to participate in our hosted exchange (site to be determined).  You participate in the exchange by writing a client program against the Magex API to place your buy and sell orders.

Commodities listed on the Magical Exchange include:

- Wishing Wands (wish)
- Flying Carpets (flyc)
- Singing Swords (sisw)
- Magic Beans (mbns)
- Pixie Dust Vials (pixd)

All trades are made in gold pieces. Magex matches buy and sell orders to complete transactions. It also tracks market valuation for commodities traded on the market.

The rules of trading are simple:

- When you register a new player you automatically have 1000 gold pieces added to your account.
- You can place a buy or sell order at any time.
- Magex automatically matches buy and sell orders based on price. Given equivalent sell or buy offers, Magex matches the earliest first.
- Magex does not check your account balance until it has a possible match. This means you can place an offer to buy even if you do not have sufficient gold or an offer to sell even if you do not have a sufficient quantity of the commodity in question.
- Magex may split a buy or sell order if it can partially complete the transaction. For example, if you place an order to buy 100 wishing wands for 5 gold each, and there is an offer to sell 50 wishing wands at 5 gold, Magex will purchase the 50 wishing wands on your behalf, creating a new order for the remaining 50.

# Using the Magex API

## Registering



## Selling

Commodity symbol must be one of the commodities listed on the exchange
Min price must be a whole number

## Buying

## Querying Your Account

## Querying Orders and Transactions

### /orders/openbuy
### /orders/opensell
### /orders/transactions

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

# License

This source code is licensed under the BSD 2-clause license. See LICENSE.txt for details.

