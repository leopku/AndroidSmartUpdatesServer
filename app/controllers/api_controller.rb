class ApiController < ApplicationController

  before_filter :get_application, :get_version, :get_package_name, :is_valid

  def get_application
    if Application.exists? params[:application_id]
      @application = Application.find(params[:application_id])
    else
      render_result "application_not_existed", nil
    end
  end

  def get_version
    @current_version = @application.version.where(:version_code => params[:current_version]).first
    @last_version = @application.version.last
    render_result "current_version_not_existed", nil if @current_version.nil?
  end

  def get_package_name
    begin
      @package_name = Base64.urlsafe_decode64(params[:package_name])
    rescue
      render_result "package_name_not_match", nil and return
    end
  end

  def is_valid
    if @package_name != @application.package_name
      render_result "package_name_not_match", nil and return
    end
    unless @last_version.version_code > @current_version.version_code
      render_result "no_update", nil
    end
  end

  def update
    json = @last_version.to_json_hash
    json.merge!({"apk_patch_size" => patch_size})
    render_result "incremental", json
  end

  def download
    path = Differ::MakeVersionPatch.get_patch_file_path(@current_version, @last_version)
    send_file path
  end

  def render_result(message, information)
    render :json => {"message" => message, "information" => information}
  end

  def patch_size
    Differ::MakeVersionPatch.get_patch_size(@current_version, @last_version)
  end

  def auto_check
    logger.info(ENV['HOST'])
    logger.info(ENV['PORT'])
    @os_version = params[:os_version]
    @imei = params[:imei]
    @client_name = params[:user_name].present? ? params[:user_name] : nil
    @client_id = params[:user_id].present? ? params[:user_id] : nil

    if @os_version <= '4.1'
      render_result "full", { path: "http://#{ENV['HOST']}:#{ENV['PORT']}/development/apks/user_#{@application.user_id}/application_#{@application.id}/version_code_#{@last_version.id}.apk" }
    else
      self.update
    end
  end
end
