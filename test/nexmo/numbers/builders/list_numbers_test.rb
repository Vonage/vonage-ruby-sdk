# typed: false

class Nexmo::Numbers::Builders::ListNumbersTest < Nexmo::Test
  def test_with_no_parameters
    builder = Nexmo::Numbers::Builders::ListNumbers.new

    assert builder
  end

  def test_with_all_parameters
    params = {
      application_id: '123456789',
      has_application: false,
      country: 'US',
      pattern: '123',
      search_pattern: 1,
      size: 10,
      index: 1
    }

    builder = Nexmo::Numbers::Builders::ListNumbers.new(params)

    assert_equal builder.application_id, params[:application_id]
    assert_equal builder.has_application, params[:has_application]
    assert_equal builder.country, params[:country]
    assert_equal builder.pattern, params[:pattern]
    assert_equal builder.search_pattern, params[:search_pattern]
    assert_equal builder.size, params[:size]
    assert_equal builder.index, params[:index]
  end

  def test_with_incorrect_application_id_param
    params = {
      application_id: 1234
    }

    exception = assert_raises { Nexmo::Numbers::Builders::ListNumbers.new(params) }

    assert_match "Expected 'application_id' parameter to be a String", exception.message
  end

  def test_with_incorrect_has_application_param
    params = {
      has_application: 'sure'
    }

    exception = assert_raises { Nexmo::Numbers::Builders::ListNumbers.new(params) }

    assert_match "Expected 'has_application' parameter to be a Boolean", exception.message
  end

  def test_with_incorrect_country_param_type
    params = {
      country: 1
    }

    exception = assert_raises { Nexmo::Numbers::Builders::ListNumbers.new(params) }

    assert_match "Expected 'country' parameter to be a String", exception.message
  end

  def test_with_incorrect_country_param_value
    params = {
      country: 'USA'
    }

    exception = assert_raises { Nexmo::Numbers::Builders::ListNumbers.new(params) }

    assert_match "Expected 'country' parameter to be in ISO 3166 alpha-2 format", exception.message
  end

  def test_with_incorrect_pattern_param
    params = {
      pattern: 1
    }

    exception = assert_raises { Nexmo::Numbers::Builders::ListNumbers.new(params) }

    assert_match "Expected 'pattern' parameter to be a String", exception.message
  end

  def test_with_incorrect_search_pattern_param_type
    params = {
      search_pattern: '1'
    }

    exception = assert_raises { Nexmo::Numbers::Builders::ListNumbers.new(params) }

    assert_match "Expected 'search_pattern' parameter to be an Integer", exception.message
  end

  def test_with_incorrect_search_pattern_param_value
    params = {
      search_pattern: 4
    }

    exception = assert_raises { Nexmo::Numbers::Builders::ListNumbers.new(params) }

    assert_match "Expected 'search_pattern' value to be one of: 0, 1, 2", exception.message
  end

  def test_with_incorrect_size_param
    params = {
      size: '4'
    }

    exception = assert_raises { Nexmo::Numbers::Builders::ListNumbers.new(params) }

    assert_match "Expected 'size' parameter to be an Integer", exception.message
  end

  def test_with_incorrect_index_param
    params = {
      index: '4'
    }

    exception = assert_raises { Nexmo::Numbers::Builders::ListNumbers.new(params) }

    assert_match "Expected 'index' parameter to be an Integer", exception.message
  end
end