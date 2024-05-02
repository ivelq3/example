RSpec::Matchers.define :be_failure_of do |expected|
  match {|obj| obj.failure == expected }
end
