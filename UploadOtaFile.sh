set -ix
# FILE=ota-image@zigbee@e024@door-contact@v0e

FILE=ota-image@zigbee@e024@smart-plug@v0a
# FILE=ota-image@zigbee@e024@smart-plug@v0b
# FILE=ota-image@zigbee@e024@smart-plug@v0c

ossclient.py --overwrite ${FILE} io-xiaoyan-release-bucket-root/ota-test-files/${FILE}
