#!/bin/sh

# set up chains
ipset restore < /etc/ipset.HR.save;
                
iptables -N HROnly
iptables -A HROnly -m set --match-set hrvatska4 src -j ACCEPT
iptables -A HROnly -j DROP

ip6tables -N HROnly
ip6tables -A HROnly -m set --match-set hrvatska6 src -j ACCEPT
ip6tables -A HROnly -j DROP

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

# allow ssh connection only from country HR
ipt46 -A INPUT -p tcp -m state --state NEW --dport 22 -j HROnly

ipt46 -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7
ipt46 -A INPUT -j DROP
