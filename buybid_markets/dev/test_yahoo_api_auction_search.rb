
def print_hash(h,spaces=4,level=0)
  h.each do |key,val|
    format = "    #{' '*spaces*level}#{key}: "
    if val.is_a? Hash
      puts format
      print_hash(val,spaces,level+1)
    else
      puts format + val.to_s
    end
  end
end
res = Yahoo::Api.get(Yahoo::Api::Auction::Search,{:category => "0",:start => "5000", :results => "100"})
puts res.code # 200
puts res.message # "OK"
binding.pry
res["ResultSet"]["Result"]["Item"].each do |auction|
	puts "Auction: #{auction["AuctionID"]}"
	print_hash(auction)
end
