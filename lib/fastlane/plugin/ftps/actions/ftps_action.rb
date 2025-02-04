require 'net/ftp'
require 'ruby-progressbar'

module Fastlane
  module Actions
    class FtpsAction < Action
      def self.run(params)
        FtpsAction.put(params) if params[:upload]

        FtpsAction.upload_multiple(params) if params[:upload_multiple]

        return unless params[:download]

        FtpsAction.get(params)
      end

      def self.ensure_remote_path(ftp, folder)
        parts = folder.split('/')
        current_path = ''
        parts.each do |part|
          # Pomijamy puste elementy (np. jeśli folder zaczyna się od '/')
          next if part.empty?

          current_path = "#{current_path}/#{part}"
          begin
            ftp.chdir(current_path)
          rescue Net::FTPPermError
            ftp.mkdir(part)
            ftp.chdir(current_path)
          end
        end
        ftp.chdir('~/')
      end

      def self.connect_ftp(params)
        open(params)
      end

      def self.open(params)
        ftp = Net::FTP.new(params[:host], params[:options])
        ftp.connect(params[:host], params[:port])
        ftp.login(params[:username], params[:password])
        ftp.passive = true
        UI.success("Successfully Login to #{params[:host]}:#{params[:port]}")
        ftp
      end

      def self.put(params)
        ftp = connect_ftp(params)
        ensure_remote_path(ftp, params[:upload][:dest])
        ftp.chdir(params[:upload][:dest])
        filesize = File.size(params[:upload][:src])
        progressbar.total = filesize
        ftp.putbinaryfile(params[:upload][:src], params[:upload][:src].split('/').last) do |data|
          progressbar.progress += data.size
        end
        ftp.close
        UI.success("Successfully uploaded #{params[:upload][:src]}")
      end

      def self.get(params)
        ftp = connect_ftp(params)
        UI.success("Successfully Login to #{params[:host]}:#{params[:port]}")
        ftp.getbinaryfile(params[:download][:src], params[:download][:dest]) do |data|
        end
        ftp.close
        UI.success("Successfully download #{params[:download][:dest]}")
      end

      def self.upload_multiple(params)
        ftp = connect_ftp(params)

        # Upewniamy się, że ścieżka (folder) do której wgrywamy istnieje.
        base_file_path = params[:upload_multiple][:base_file_path]
        file_paths = params[:upload_multiple][:src]

        remote_base = params[:upload_multiple][:dest]
        ensure_remote_path(ftp, remote_base)

        # total_size = file_paths.reduce(0) { |sum, file_path| sum + File.size(file_path) }
        # progressbar = ProgressBar.create(
        #   format: '%a |%b>>%i| %p%% %t',
        #   total: total_size,
        #   starting_at: 0
        # )

        file_paths.each do |local_file|
          UI.success("Successfully try #{local_file}")

          next unless File.file?(local_file)

          relative_path = local_file.sub(%r{\A#{Regexp.escape(base_file_path)}/?}, '')
          UI.success("Successfully download #{local_file} #{base_file_path} #{relative_path}")

          dir_name  = File.dirname(relative_path)
          file_name = File.basename(relative_path)

          dir_name = '' if dir_name == '.'

          remote_path = if dir_name.empty?
                          remote_base
                        else
                          File.join(remote_base, dir_name)
                        end

          UI.success("Successfully ensure_remote_path #{remote_path}")
          ensure_remote_path(ftp, remote_path)
          ftp.chdir(remote_path)
          ftp.putbinaryfile(local_file, file_name)
          UI.message("Uploaded #{local_file} -> #{File.join(remote_path, file_name)}")
        end

        ftp.close
        UI.success("Successfully uploaded all files to #{params[:upload_multiple][:dest]}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Upload and Download files via FTP'
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        'Transfer files via FTP, and create recursively folder for upload action'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :username,
                                       short_option: '-u',
                                       env_name: 'FL_FTP_USERNAME',
                                       description: 'Username',
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :password,
                                       short_option: '-p',
                                       env_name: 'FL_FTP_PASSWORD',
                                       description: 'Password',
                                       optional: false,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :host,
                                       short_option: '-H',
                                       env_name: 'FL_FTP_HOST',
                                       description: 'Hostname',
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :folder,
                                       short_option: '-f',
                                       env_name: 'FL_FTP_FOLDER',
                                       description: 'repository',
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :upload,
                                       short_option: '-U',
                                       env_name: 'FL_FTP_UPLOAD',
                                       description: 'Upload',
                                       optional: true,
                                       is_string: false,
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :upload_multiple,
                                       short_option: '-I',
                                       env_name: 'FL_FTP_UPLOAD_MULTIPLE',
                                       description: 'Upload',
                                       optional: true,
                                       is_string: false,
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :download,
                                       short_option: '-D',
                                       env_name: 'FL_FTP_DOWNLOAD',
                                       description: 'Download',
                                       optional: true,
                                       is_string: false,
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :options,
                                       short_option: '-O',
                                       env_name: 'FL_FTP_OPTIONS',
                                       description: 'options',
                                       optional: true,
                                       is_string: false,
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :port,
                                       short_option: '-P',
                                       env_name: 'FL_FTP_PORT',
                                       description: 'Port',
                                       optional: true,
                                       default_value: 21,
                                       is_string: false,
                                       type: Integer)
        ]
      end

      def self.output; end

      def self.return_value; end

      def self.authors
        ['Allan Vialatte, Rafał Dziuryk']
      end

      def self.is_supported?(_platform)
        true
      end
    end
  end
end
