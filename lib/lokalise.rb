require 'rest-client'

require "lokalise/constants"
require "lokalise/version"
require "lokalise/urls"

module Lokalise
  if ENV['LOKALISE_ACCESS_TOKEN']
    ACCESS_TOKEN = ENV['LOKALISE_ACCESS_TOKEN']
  else
    at_exit { puts "Environment Variable LOKALISE_ACCESS_TOKEN is required" }
    exit
  end

  DEFAULT_PARAMS = {"api_token" => ACCESS_TOKEN}
  BASE_API_URL = "https://api.lokalise.co/api/"

  def self.alive?()
    url = construct_api_url(Lokalise::URLS[:alive])
    res = RestClient.get(url, {params: DEFAULT_PARAMS})
    res.code == 200 ? true : false
  end

  def self.get_projects()
    url = construct_api_url(Lokalise::URLS[:project_list])
    res = RestClient.get(url, {params: DEFAULT_PARAMS})

    if res.code == 200
      op = parse_response_body res.body
      op["projects"]
    else
      # TODO: Handle these
      puts "Non 200 responses"
    end
  end

  def self.import_keys(project_id, file_path, lang_iso, options={})
    if options_match?(options, 'import')
      params = DEFAULT_PARAMS.clone
      params['id'] = project_id
      params['file'] = File.new(file_path)
      params['lang_iso'] = lang_iso
      params.update(options)

      url = construct_api_url(Lokalise::URLS[:import])
      res = RestClient.post(url, params)
      JSON.parse(res)["response"]["message"]
    else
      "Incorrect optional params"
    end
  end

  def self.export_keys(project_id, type, options={})
    if options_match?(options, 'export')
      params = DEFAULT_PARAMS.clone
      params['id'] = project_id
      params['type'] = type
      params.update(options)
      # TODO: check if the language to export is in project languages.

      url = construct_api_url(Lokalise::URLS[:export])
      res = RestClient.post(url, params)
      if res.code == 200
        file_url_prefix = "https://s3-eu-west-1.amazonaws.com/lokalise-assets/"
        return "#{file_url_prefix}#{JSON.parse(response)["bundle"]["file"]}"
      end
    end
  end

  def self.get_project_languages(project_id)
    url = construct_api_url(Lokalise::URLS[:project_languages])
    params = DEFAULT_PARAMS.clone
    params["id"] = project_id
    res = RestClient.get(url, {params: params})
    if res.code == 200
      json_response = parse_response_body(res)
      languages = json_response["languages"]
      languages.collect {|lang| "#{lang['name']}(#{lang['iso']})"}
    end
  end

  def self.options_match?(options, action)
    check_options = get_check_options(action)
    keys = options.keys
    keys.all? { |k| check_options.include?(k) }
  end

  def self.get_check_options action
    case action
    when action == 'import'
      return Lokalise::IMPORT_OPTIONS
    when action == 'export'
      return Lokalise::EXPORT_OPTIONS
    end
  end

  def self.construct_api_url uri
    URI.join(BASE_API_URL, uri).to_s
  end

  def self.parse_response_body raw_response
    JSON.parse raw_response
  end
end
