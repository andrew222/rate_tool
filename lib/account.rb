module Account
  class VPNClient
    def add_account(user_name, password, file="/etc/ppp/chap-secrets")
      client = %x[sed -i -e "$G" -e "\$a#{user_name}\t#{password}\t\*" -n "#{file}"]
      unless client.blank
        ""
      else
        client.split("\t")
      end
    end
  end
end
