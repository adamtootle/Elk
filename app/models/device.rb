class Device < ActiveRecord::Base
  attr_accessible :UDID, :model, :user_id

  belongs_to :user

  MODEL_NAMES = {
    'iPad1' => 'iPad 1G',
    'iPad2' => 'Ipad 2',
    'iPad3' => 'iPad 3',

    'iPhone1,1' => 'iPhone 2G',

    'iPhone1,2' => 'iPhone 3G',

    'iPhone2,1' => 'iPhone 3GS',

    'iPhone3,1' => 'iPhone 4',
    'iPhone3,2' => 'iPhone 4',
    'iPhone3,3' => 'iPhone 4',

    'iPhone4,1' => 'iPhone 4s',

    'iPhone5,1' => 'iPhone 5',
    'iPhone5,2' => 'iPhone 5',

    'iPhone5,3' => 'iPhone 5c',
    'iPhone5,4' => 'iPhone 5c',

    'iPhone6,1' => 'iPhone 5s',
    'iPhone6,2' => 'iPhone 5s',

    'iPhone7,2' => 'iPhone 6',

    'iPhone7,1' => 'iPhone 6 Plus'
  }

  def friendly_model
    Device::MODEL_NAMES[self.model]
  end
end
