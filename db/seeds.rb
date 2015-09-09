require './db/small_seed'
require './db/big_seed'

if Rails.env.production?
  BigSeed::Seed.new.run
else
  SmallSeed::Seed.new.run
end
