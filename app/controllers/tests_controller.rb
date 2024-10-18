class TestsController < ApplicationController
  def upload_file
    uploaded_file_path = Rails.public_path.join('big_file.txt')
    
    FileUtils.cp(uploaded_file_path, Rails.root.join('public/uploads/big_file.txt'))
    puts "Файл #{uploaded_file_path} загружен."
  end

  def download_file

    downloaded_file_path = Rails.public_path.join('big_file.txt')

    if File.exist?(downloaded_file_path)
      send_file(downloaded_file_path, type: 'application/octet-stream', disposition: 'attachment')
      puts "Файл #{downloaded_file_path} скачан."
      return downloaded_file_path
    else
      puts "Файл не найден: #{downloaded_file_path}"
      render json: { error: "Файл не найден: #{downloaded_file_path}" }, status: :not_found
    end
  end

  def start
    user_agent = request.user_agent

    start_download_time = Time.now
    downloaded_file = download_file
    download_time = Time.now - start_download_time

    start_upload_time = Time.now
    upload_file
    upload_time = Time.now - start_upload_time
    

    test_result = TestResult.new(
      upload_time: upload_time,
      download_time: download_time,
      user_agent: user_agent
    )

    if test_result.save
      render json: { message: 'Тестирование завершено', result: test_result, downloaded_file: downloaded_file }, status: :ok
    else
      render json: { errors: test_result.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
