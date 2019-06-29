require 'net/http'
require 'uri'
require 'json'
require 'mime/types'

uri = URI.parse("https://auctions.yahoo.co.jp/jp/config/placebid")
BOUNDARY = "AaB03x"

header = { "Content-Type": "multipart/form-data, boundary=#{BOUNDARY}" }
user = {
	Partial: 0,
	ItemID: "o310749063",
	login: "suresh_3971",
	cc: "jp",
	Quantity: "1",
	Bid: "20",
	bidType: "",
	a: "dj0zaiZpPU9jRE5IdWYyQVFOaCZkPVlXazlaVlp6UmxGTE5XRW1jR285TUEtLSZzPWNvbnN1bWVyc2VjcmV0Jng9M2M-",
	u: ""
}

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri, header)
request.body = user.to_json

response = http.request(request)
