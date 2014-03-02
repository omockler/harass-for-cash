require 'benchmark'
require 'faker'
require 'json'
require 'mechanize'

# number of users needed
num_codes = 500

uri = URI("http://localhost:9292/codes/sekret/#{num_codes}")
codes = JSON.parse Net::HTTP.get(uri)

puts "Checking num codes"
unless codes.length >= num_codes
  puts "Not Enough codes, getting more"
  Benchmark.measure {
    new_codes_uri = URI("http://localhost:9292/codes/sekret/#{num_codes - codes.length}")
    codes = JSON.parse Net::HTTP.get(new_codes_uri)
  }
end

codes = codes.take num_codes

puts "We have enough codes starting load test"
agent = Mechanize.new

puts Benchmark.measure {
  codes.each do |code|
    new_hacker_page = agent.get(URI("http://localhost:9292/hackers/new/#{code}"))
    new_hacker_form = new_hacker_page.form
    new_hacker_form.full_name = Faker::Lorem.words(2).join " "
    new_hacker_form.email = "#{Faker::Lorem.word}@test.com"
    agent.submit(new_hacker_form, new_hacker_form.buttons.first)
  end
}

puts "Entering the raffle"
puts Benchmark.measure {
  codes.each do |code|
    enter_page = agent.get(URI("http://localhost:9292/enter/#{code}"))
  end
}