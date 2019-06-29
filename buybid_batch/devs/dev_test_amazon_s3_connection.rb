require 'aws-sdk-s3'

puts "#{ENV['S3_REGION']}"

s3 = Aws::S3::Resource.new(region: ENV['S3_REGION'])

bucket = s3.bucket(ENV['S3_BUCKET_NAME'])
#bucket.create

object = bucket.object('ruby_sample_key.txt')
object.put(body: "Hello World!")

puts "Created an object in S3 at:"
puts object.public_url

puts "\nUse this URL to download the file:"
puts object.presigned_url(:get)
