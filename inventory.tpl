[public]
%{ for ip in app_ips ~}
${ip} 
%{ endfor ~}

[private]
${db_ip} 

[public:vars]
database_host='${db_ip}'

[private:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ubuntu@${app_ips[0]} -i ../public.pem"'