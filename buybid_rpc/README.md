# BuybidRpc
Short description and motivation. 
Use GRPC for ruby from https://github.com/bigcommerce/gruf

## Usage
- Generate RPC protos
> grpc_tools_ruby_protoc -I ./rpc --ruby_out=./rpc/protos --grpc_out=./rpc/protos/services ./rpc/markets.proto

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'buybid_rpc'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install buybid_rpc
```