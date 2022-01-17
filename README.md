# check_mac_address
Nagios check_mac_address plugin

The plugin has only one option, "-M <mac address>"
  
Example command definition in commands.cfg
  
  define command {

    command_name    check_mac_address
    command_line    $USER1$/check_mac_address.sh -M $MAC_ADDRESS$
  }

Example service definition
  
  define service {
    use                     generic-service
    host_name               <hostname>
    service_description     Mac Address Ping
    check_command           check_mac_address!-M <aa:bb:cc:00:11:22>
  }
  
Optional: add a dummy check to your hostdefinition template to prevent the default check command gives you a "DOWN" status of your host
  
In commands.cfg add a dummy check command
  
  define command {

    command_name    check-dummy-alive
    command_line    $USER1$/check_dummy 0
}

and change the check_command in your host template in templates.cfg to
  
     check_command                   check-dummy-alive       ; Default command to check 
  
Installation:
  1)  Download en copy the check_mac_address.sh to /usr/local/nagios/libexec
  2)  Assign execution rights to the script with 'chmod 755 /usr/local/nagios/libexec/check_mac_address.sh'
  
Enjoy !
