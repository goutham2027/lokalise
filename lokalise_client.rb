require 'open-uri'
class LokaliseClient
  # LokaliseClient.upload_yaml_file(locale: "locale of input file", tags: ["your_custom_tag"], input_file: "#{Rails.root}/tmp/test.yml")
  def self.upload_yaml_file(locale: "en", tags: [], input_file:)
    begin
      body = {
        api_token: ENV['LOKALISE_API_TOKEN'],
        id: ENV['LOKALISE_PROJECT_ID'],
        file: File.new(input_file),
        lang_iso: locale,
        replace: true,
        fill_empty: false,
        distinguish: false,
        hidden: false,
        tags: tags.to_json,
        replace_breaks: false
      }
      response = RestClient.post("https://api.lokalise.co/api/project/import", body)
      JSON.parse(response)["response"]["message"]
    rescue
      "Please correct your params"
    end
  end

  # LokaliseClient.download_yaml_file(langs: ["es"], tags: ["keys with your custom tags"])
  def self.download_yaml_files(langs: [], tags: [])
    begin
      body = {
        api_token: ENV['LOKALISE_API_TOKEN'],
        id: ENV['LOKALISE_PROJECT_ID'],
        type: "csv",
        langs: langs.to_json,
        use_original: true,
        tags: tags.to_json,
        bundle_filename: "%PROJECT_NAME%-locale_#{Time.now.strftime('%Y%m%d_%H%M%S')}.zip",
        replace_breaks: false,
        yaml_include_root: true
      }
      response = RestClient.post("https://api.lokalise.co/api/project/export", body)
      if response.code == 200
        file_url = "https://s3-eu-west-1.amazonaws.com/lokalise-assets/" + JSON.parse(response)["bundle"]["file"]
      end
      file_url
      open("#{Rails.root}/tmp/locale_files.zip", 'wb') do |file|
        file << open(file_url).read
      end
      Zip::File.open("#{Rails.root}/tmp/locale_files.zip") do |zip_file|
        zip_file.each do |f|
          f_path=File.join("#{Rails.root}/tmp/locale_files", f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) unless File.exist?(f_path)
        end
      end
    rescue
      "failed to download yaml file"
    end
  end

  def self.create_project_snapshot()
    body = {
      api_token: ENV['LOKALISE_API_TOKEN'],
      id: ENV['LOKALISE_PROJECT_ID'],
    }
    response = RestClient.post("https://api.lokalise.co/api/project/snapshot", body)
    JSON.parse(response)["response"]["message"]
  end

  def self.empty_project
    body = {
      api_token: ENV['LOKALISE_API_TOKEN'],
      id: ENV['LOKALISE_PROJECT_ID'],
    }
    response = RestClient.post("https://api.lokalise.co/api/project/empty", body)
    JSON.parse(response)["response"]["message"]
  end

  # LokaliseClient.add_or_update_keys_and_translations(data: data)
  # data = [{"key"=>"activerecord.attributes.account_user.email", "tags"=>["production", "updated value"]},
  # {"key"=>"new key", "translations"=>{"en"=>"value"}, :tags=>["new key"]}]
  def self.add_or_update_keys_and_translations(data:)
    begin
      body = {
        api_token: ENV['LOKALISE_API_TOKEN'],
        id: ENV['LOKALISE_PROJECT_ID'],
        data: data.to_json
      }
      response = RestClient.post("https://api.lokalise.co/api/string/set", body)
      JSON.parse(response)["response"]["message"]
    rescue
      "failed to do action"
    end
  end
end
