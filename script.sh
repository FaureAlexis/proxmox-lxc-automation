
# get api token and api secret from env
API_TOKEN=$(cat .env | grep API_TOKEN | cut -d '=' -f2)
API_SECRET=$(cat .env | grep API_SECRET | cut -d '=' -f2)
API_NODE=$(cat .env | grep API_NODE | cut -d '=' -f2)
TARGET_NODE=$(cat .env | grep TARGET_NODE | cut -d '=' -f2)

echo "Creating a new container"

# generate random vmid
VMID=$(shuf -i 100-99999 -n 1)
echo "VMID: $VMID"

# check if vmid is already used
response=$(curl \
  --request GET \
  --silent \
  --header "Authorization: PVEAPIToken=$API_TOKEN=$API_SECRET" \
  --url https://$API_NODE:8006/api2/json/nodes/$TARGET_NODE/lxc/$VMID)

if [ "$response" != "{\"data\":null}" ]; then
  echo "VMID $VMID is already used"
  exit 1
fi

# create lxc container
# args
# vmid : $VMID 
# ostemplate : local-hdd-templates:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst = OS template (debian 12)
# pool : ASD-202410 = storage pool
# net0 : name=eth0,bridge=vmbr2,firewall=1 = network interface with firewall enabled
# cores : 1 = 1 CPU core
# start : 1 = start after creation
# rootfs : local-nvme-datas:8 = 8GB rootfs
response=$(curl \
  --request POST \
  --silent \
  --url https://$API_NODE:8006/api2/json/nodes/$TARGET_NODE/lxc \
  --header "Authorization: PVEAPIToken=$API_TOKEN=$API_SECRET" \
  --data vmid=$VMID \
  --data-urlencode ostemplate=local-hdd-templates:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst \
  --data-urlencode pool=ASD-202410 \
  --data-urlencode net0="name=eth0,bridge=vmbr2,firewall=1" \
  --data cores=1 \
  --data start=1 \
  --data-urlencode rootfs=local-nvme-datas:8) 

data=$(echo $response | jq '.data')
echo "Response: $data"

echo "Container created"