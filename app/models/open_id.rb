class OpenId < ActiveRecord::Base

  # Schema for OpenID Attribute Exchange
  #  ref) http://www.axschema.org/types/
  ATTRIBUTES = {
    :nickname    => 'http://axschema.org/namePerson/friendly',
    :email       => 'http://axschema.org/contact/email',
    :profile_pic => 'http://axschema.org/media/image/default',
    :full_name   => 'http://axschema.org/namePerson',
    :first_name  => 'http://axschema.org/namePerson/first',
    :last_name   => 'http://axschema.org/namePerson/last',
    :gender      => 'http://axschema.org/person/gender',
    :language    => 'http://axschema.org/pref/language'
  }

  def self.op_identifier_for(provider)
    case provider.to_s
    when 'google'
      "https://www.google.com/accounts/o8/id"
    when 'yahoo'
      "http://www.yahoo.com/"
    when 'yahoo_japan'
      "http://www.yahoo.co.jp/"
    end
  end

  def self.extention_fields_for(op_identifier, extensions = {})
    fields = {}
    if extensions[:ax]
      fields[:required] = OpenId::ATTRIBUTES.values_at(:nickname, :email)
      fields[:optional] = OpenId::ATTRIBUTES.values_at(:full_name, :first_name, :last_name, :profile_pic, :gender, :language)
    end
    if extensions[:ui]
      fields['ui[mode]'] = 'popup'
      fields['ui[icon]'] = true
    end
    if extensions[:oauth]
      # TODO
    end
    fields
  end

  def ax_response=(response)
    if response
      write_attribute(:ax_response, response.data.to_json)
    end
  end

  def ax_response
    if response_json = read_attribute(:ax_response)
      response = OpenID::AX::FetchResponse.new
      JSON.parse(response_json).each do |type_url, value|
        response.set_values type_url, value
      end
      response
    end
  end

  def oauth_response=(response)
    # TODO
  end

  def oauth_response
    # TODO
  end

end
