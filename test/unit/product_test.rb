require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products 
  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:price].any?
  	assert product.errors[:image_url].any?
  end
  #. . . 
  test "product price must be positive" do
  	product = Product.new(:title				=> "My Book Title",
  												:description	=> "yyy",
  												:image_url		=> "zzz.jpg")
		product.price = -1
		assert product.invalid?
		assert_equal "must be greater than or equal to 0.01",
			product.errors[:price].join('; ')  	

		product.price = 0.001
		assert product.invalid?
		assert_equal "must be greater than or equal to 0.01",
			product.errors[:price].join('; ')  	

		product.price = 1
		assert product.valid?
  end
  #. . .
  def new_product(image_url)
  	Product.new(:title				=> "My Book Title",
								:description	=> "yyy",
								:price				=> 1,
								:image_url		=> image_url)
  end

  test "product image_url has correct ending" do
  	ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
  					http://a.b.c/x/y/z/fred.gif }
  	bad = %w{ fred.doc fred.gif/more fred.gif.more }

  	ok.each do |name|
  		assert new_product(name).valid?, "#{name} shouldn't be invalid"
  	end

  	bad.each do |name|
  		assert new_product(name).invalid?, "#{name} shouldn't be valid"
  	end
  end
  #. . .
  test "product is not valid without a unique title" do
    product = Product.new(:title        => products(:ruby).title,
                          :description  => "yyy",
                          :price        => 1,
                          :image_url    => "fred.gif")
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
    # assert_equal product.translate('activerecord.errors.messages.taken'),
                 # product.errors[:title].join('; ')
  end
  #. . .
  test "product is not valid without a unique title - i18n" do
    product = Product.new(:title        => products(:ruby).title,
                          :description  => "yyy",
                          :price        => 1,
                          :image_url    => "fred.gif")
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
                  product.errors[:title].join('; ')
  end
  #. . .
  test "product title is valid with ten or more characters" do
    product = Product.new(:title        => "1234567890",
                          :description  => "yyy",
                          :price        => 1,
                          :image_url    => "fred.gif")
    assert product.valid?, 'has <= 9 characters. Valid expects >= 10.'

    product.title = "1234567891011"
    assert product.valid?, 'has <= 9 characters. Valid expects >= 10.'
  end
    
  test "product title is invalid with nine or fewer characters" do
    product = Product.new(:title        => "123456789",
                          :description  => "yyy",
                          :price        => 1,
                          :image_url    => "fred.gif")
    assert product.invalid?, 'has >=10 characters. Invalid should be < 10.'

    product.title = "12345"
    assert product.invalid?, 'has >=10 characters. Invalid should be < 10.'
  end
  #. . .
  #. . .
end
