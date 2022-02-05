require 'mechanize'
require 'faraday'


class VkApi
    def initialize(email, pass, client_id)
        browser = Mechanize.new {|b| b.user_agent_alias = 'Windows Chrome' 
            b.follow_meta_refresh}
        page = browser.get("https://oauth.vk.com/authorize?client_id=#{client_id}&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=4&response_type=token&v=5.52")
        login = page.forms.first
        login.email = email
        login.pass = pass
        page = login.submit
        hash = URI.decode_www_form(page.uri.query).to_h
        norm_url = CGI.unescape(hash['authorize_url'])
        @auth_token = norm_url.match(/=[^&]*/).to_s
        @auth_token[0] = ''
        @version = '5.81'
    end

    def request_method(method, c='')
        params = '?'+c
        request = Faraday.get("https://api.vk.com/method/#{method}#{params}&access_token=#{@auth_token}&v=#{@version}")
        request.body
    end
end

vk = VkApi.new
vk.request_method 'account.getAppPermission', 'user_id=167012209&'
puts vk.request_method 'messages.send', 'user_id=197054533&message="hehe"'
