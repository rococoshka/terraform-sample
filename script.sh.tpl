#!/bin/bash
sudo apt -y update
sudo apt -y install nginx
cat <<EOF  > /var/www/html/index.html
<html>
"<h2>Hello from terraform<h2>
Owner ${f_name} ${l_name}
%{ for x in names ~}
Hello to ${x} from ${f_name}
%{ endfor ~}
</html>
EOF
sudo service nginx start