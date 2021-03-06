require 'test/unit'
require 'string_internals'

# XXX 1.9 specific tests
class TestStringInternals < Test::Unit::TestCase
  def test_buffer
    # minimum 128 buffer size
    str = String.buffer(10)
    assert_equal 128, str.capacity

    # larger than min buffer size
    str = String.buffer(200)
    assert_equal 200, str.capacity

    # capacity 200, but still an empty string
    assert_equal str, ""

    # beef it up, enough capacity, no memcpy
    100.times{|i| str << i }
    # larger size
    assert_equal 100, str.size
    # capacity shrunk to 100 chars
    assert_equal 100, str.capacity

    # some more
    100.times{|i| str << i }
    # larger size
    assert_equal 200, str.size
    # size == capacity now, next modification will allocate a large buffer
    assert_equal 200, str.capacity

    str << "*"
    # going over, buffer doubles, capa = (capa + 1) * 2
    assert_equal 201, str.size
    assert_equal 402, str.capacity
  end

  def test_capacity
    str = "test_capacity_str"
    assert_equal 17, str.size
    assert_equal 0, str.capacity

    # anticipatory string capacity, capa = (capa + 1) * 2
    str << "_larger"
    assert_equal 24, str.size
    assert_equal 48, str.capacity

    # notice larger string capacity still accommodates this modification
    str << "_largest"
    assert_equal 32, str.size
    assert_equal 48, str.capacity

    # exceed the 36 char capacity, capa = (capa + 1) * 2
    str << "_moar"
    assert_equal 37, str.size
    assert_equal 48, str.capacity

    str = "a"
    assert_equal 1, str.size
    assert_equal 0, str.capacity

    # string made independent has size == capacity
    str2 = str.succ
    assert_equal 1, str2.size
    assert_equal 0, str2.capacity

    str = "gsub"
    assert_equal 4, str.size
    assert_equal 0, str.capacity

    str.gsub!(/b/,"gsub")
    assert_equal 7, str.size
    # anticipatory string capacity
    assert_equal 0, str.capacity
  end

  def test_shared
    str = "random_string"
    assert str.shared?
    str2 = "random_string"
    assert str2.shared?

    # non-literal strings are not shared
    str3 = :other_string.to_s
    assert !str3.shared?

    str4 = self.class.to_s
    assert str4.shared?

    str5 = "str"
    str5.concat("ing")
    assert !str5.shared?

    # shares a single char pointer
    str6 = nil
    500.times do
      str6 = "looped str"
      str6.concat("ing")
    end
    assert str6.shared?
    assert_equal false, str6.shared
    assert_equal 54, str.obj_size

    str7 = str5.replace("string")
    assert !str7.shared?
    assert !str5.shared?
    assert_equal str5.object_id, str7.object_id
    assert_equal str5.shared.object_id, str7.shared.object_id

    str << str2
    assert !str.shared?
    assert str2.shared?
    assert_equal nil, str.shared

    str2.gsub!(/random/,"")
    assert !str.shared?
    assert_equal nil, str.shared

    assert "def".reverse!().shared?
  end

  def test_associated
    a = [ "a", "b", "c" ]
    str = a.pack("p")
    assert_equal "\x90Y\x00\x02\x01\x00\x00\x00", str
    assert str.associated?
  end

  def test_obj_size
    # object size is struct size + (len || capa) + 1 for sentinel ('\0')
    # struct size (RString) is 20 bytes on 32bit and 40 bytes on 64bit platforms
    str = "string"
    assert_equal 47, str.obj_size

    assert_equal 169, String.buffer(10).obj_size
    assert_equal 241, String.buffer(200).obj_size

    str = "test_obj_size_str"
    assert_equal 58, str.obj_size

    str << "_much_larger"
    assert_equal 89, str.obj_size
  end
end