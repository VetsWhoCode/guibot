
Paulo Abreu [14:39]
added a Ruby snippet
require 'sinatra'
require 'httparty'
require 'json'
​
post '/gateway' do
  message = params[:text].gsub(params[:trigger_word], '').strip
​
  action, repo = message.split('_').map {|c| c.strip.downcase }
  repo_url = "https://api.github.com/repos/#{repo}"
​
  case action
    when 'issues'
      resp = get_repository_details(repo_url)
      respond_message "There are #{resp['open_issues_count']} open issues on #{repo}"
​
    when 'commits'
      resp = get_repository_details(repo_url)
      respond_message "There are #{resp['commits_count']} commits on #{repo}"
  end
end
​
def respond_message message
  content_type :json
  {:text => message}.to_json
end
​
def get_repository_details(repo_url)
  resp = HTTParty.get(repo_url)
  JSON.parse resp.body
end
