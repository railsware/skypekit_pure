require 'test_helper'
require 'skypekit_pure'

class SkypekitPureTest < ActiveSupport::TestCase
  test "the truth" do
     assert true
     skype = SkypekitPure.connect('/home/leo/programs/skypekit/keys/key.pem')
     skype.disconnect
  end
end
