#!/bin/sh

# set up chains
ipset restore < /etc/ipset.HR_BA.save;
                
iptables -N HROnly
iptables -A HROnly -m set --match-set HR4 src -j ACCEPT
iptables -A HROnly -j DROP

ip6tables -N HROnly
ip6tables -A HROnly -m set --match-set HR6 src -j ACCEPT
ip6tables -A HROnly -j DROP

iptables -N HR_BA_Only
iptables -A HR_BA_Only -m set --match-set HR4 src -j ACCEPT
iptables -A HR_BA_Only -m set --match-set BA4 src -j ACCEPT
iptables -A HR_BA_Only -j DROP

ip6tables -N HR_BA_Only
ip6tables -A HR_BA_Only -m set --match-set HR6 src -j ACCEPT
ip6tables -A HR_BA_Only -m set --match-set BA6 src -j ACCEPT
ip6tables -A HR_BA_Only -j DROP

# helper function
ipt46()
{
	iptables "$@"
	ip6tables "$@"
}

# example usage
ipt46 -A INPUT -i lo -j ACCEPT
ipt46 -A INPUT -p icmp -j ACCEPT
ipt46 -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
ipt46 -A INPUT -p tcp --dport 80 -j ACCEPT

# allow ssh connection only from country HR, and mysql from HR and BA
ipt46 -A INPUT -p tcp -m state --state NEW --dport 22 -j HROnly
ipt46 -A INPUT -p tcp -m state --state NEW --dport 3306 -j HR_BA_Only

ipt46 -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7
ipt46 -A INPUT -j DROP
