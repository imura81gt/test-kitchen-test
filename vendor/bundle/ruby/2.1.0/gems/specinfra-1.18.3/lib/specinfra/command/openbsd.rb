module SpecInfra
  module Command
    class OpenBSD < Base
      def check_enabled(service, level=3)
        "egrep '(#{escape(service)}_flags=|^pkg_scripts=\"(.*)#{escape(service)}(.*)\")' /etc/rc.conf.local | grep -v \=NO"
      end

      def check_file_md5checksum(file, expected)
        regexp = "^#{expected}"
        "cksum -qa md5 #{escape(file)} | grep -w #{escape(regexp)}"
      end

      def check_file_sha256checksum(file, expected)
        regexp = "^#{expected}"
        "cksum -qa sha256 #{escape(file)} | grep -w #{escape(regexp)}"
      end

      def check_login_shell(user, path_to_shell)
        "getent passwd #{escape(user)} | cut -f 7 -d ':' | grep #{escape(path_to_shell)}"
      end

      def check_home_directory(user, path_to_home)
        "getent passwd #{escape(user)} | cut -f 6 -d ':' | grep #{escape(path_to_home)}"
      end

      def check_installed(package, version=nil)
        if version
          "pkg_info -a | cut -d ' ' -f 1 | grep  #{escape(package)}-#{escape(version)}"
        else
          "pkg_info -a | cut -d ' ' -f 1 | grep  #{escape(package)}"
        end
      end

      def get_interface_speed_of(name)
        "ifconfig #{name} | grep 'media\:' | perl -pe 's|.*media\:.*\\((.*?)\\)|\\1|'"
      end

      def check_ipv4_address(interface, ip_address)
        "ifconfig #{interface} | grep -w inet | cut -d ' ' -f 2"
      end

      def check_listening(port)
        "netstat -nat -f inet | egrep '((tcp|udp).*\.#{port}.*LISTEN$)'"
      end

      def check_mail_alias(recipient, target)
        "egrep '^#{escape(recipient)}:.*#{escape(target)}' /etc/mail/aliases"
      end

      def check_link(link, target)
        "stat -f %Y #{escape(link)} | grep -- #{escape(target)}"
      end

      def check_mode(file, mode)
        regexp = "^#{mode}$"
        "stat -f%Lp #{escape(file)} | grep #{escape(regexp)}"
      end

      def check_owner(file, owner)
        regexp = "^#{owner}$"
        "stat -f %Su #{escape(file)} | grep -- #{escape(regexp)}"
      end

      def check_grouped(file, group)
        regexp = "^#{group}$"
        "stat -f %Sg #{escape(file)} | grep -- #{escape(regexp)}"
      end

      def check_mounted(path)
        regexp = "on #{path} "
        "mount | grep #{escape(regexp)}"
      end

#      def check_routing_table(destination)
#        "route -n show -gateway | egrep '(^default|#{destination})' | head -1"
#      end

      def check_running(service)
        "/etc/rc.d/#{escape(service)} status"
      end

      def get_mode(file)
        "stat -f%Lp #{escape(file)}"
      end

      def install(package)
        "pkg_add #{package}"
      end
    end
  end
end
