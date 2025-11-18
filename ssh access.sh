sudo awk -i inplace '
/^#?PasswordAuthentication/ {print "PasswordAuthentication yes"; next}
/^#?KbdInteractiveAuthentication/ {print "KbdInteractiveAuthentication yes"; next}
/^#?UsePAM/ {print "UsePAM yes"; next}
{print}
' /etc/ssh/sshd_config
sudo systemctl restart ssh
