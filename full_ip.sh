# Script by Fonta22 (2022)
# Repo: https://github.com/Fonta22/repo

url=http://ipecho.net/plain

nc='\033[0m'
color='\033[1;32m'

if [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
    echo "[v1.0.0]"
    echo "Show ip addresses"
    echo "options:"
    echo "      -h                  show this help menu"
    echo "      -oF file            save full command in output file"
    echo "      -oP file            save plain ip addresses to output file"

    exit 0
fi

public_ip() {
    wget $url -O - -q ; echo
}

private_ip() {
    if [ "$1" = "v4" ]
    then
        ip addr show eth0 | grep 'inet ' | awk '{ print $2; }' | sed 's/\/.*$//'
    elif [ "$1" = "v6" ]
    then
        ip addr show eth0 | grep 'inet6' | awk '{ print $2; }' | sed 's/\/.*$//'
    fi
}

echo "- [PUBLIC]"
echo -n "       - [IPv4]: "
echo -n $color
public_ip

echo $nc
echo "- [PRIVATE]"
echo -n "       - [IPv4]: "
echo -n $color
private_ip "v4"

echo -n $nc
echo -n "       - [IPv6]: "
echo -n $color
private_ip "v6"

echo -n $nc

if [ "$1" = "-oF" ]
then
    echo "$0 $@\n" > $2
    $0 >> $2

    echo "\nSaved to $2 (FULL)"
elif [ "$1" = "-oP" ]
then
    echo "$0 $@\n" > $2
    echo "PUBLIC" >> $2
    public_ip >> $2
    echo "PRIVATE" >> $2
    private_ip "v4" >> $2
    private_ip "v6" >> $2

    echo "\nSaved to $2 (PLAIN)"
fi