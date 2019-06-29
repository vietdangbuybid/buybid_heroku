
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
res = Yahoo::Api.get(Yahoo::Api::Shopping::ItemSearch,{:category_id => "13457"})
puts res.code # 200
puts res.message # "OK"
res["ResultSet"]["totalResultsReturned"].times do |i|
	product =  res["ResultSet"]["0"]["Result"]["#{i}"]
	puts "Product: #{product["Code"]}"
	print_hash(product["Store"])
end
