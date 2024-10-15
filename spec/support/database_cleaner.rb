RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:active_record].clean_with(:truncation)
    DatabaseCleaner[:redis].strategy = :deletion
  end

  config.after(:context) do
    DatabaseCleaner.clean
  end

  config.before(:context) do
    DatabaseCleaner.start
  end
  
  config.after(:context) do
    DatabaseCleaner.clean
  end

end