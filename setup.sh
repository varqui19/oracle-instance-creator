#!/bin/bash
# Oracle Cloud Free Tier - Automated Instance Creation
# Run this script and it will keep retrying until capacity is available

set -e

echo "=========================================="
echo "Oracle Cloud Free Tier Instance Creator"
echo "=========================================="

# Check for OCI config
if [ ! -f ~/.oci/config ]; then
    echo "ERROR: OCI config not found at ~/.oci/config"
    echo ""
    echo "Setup instructions:"
    echo "1. Create Oracle Cloud account at https://cloud.oracle.com"
    echo "2. Go to Identity > Domains > Default Domain > API Keys"
    echo "3. Create API Key and download config"
    echo "4. Move config to ~/.oci/config"
    echo ""
    echo "Or run: oci setup config"
    exit 1
fi

# Clone the automation repo
if [ ! -d "oracle-freetier-instance-creation" ]; then
    git clone https://github.com/mohankumarpaluru/oracle-freetier-instance-creation.git
fi

cd oracle-freetier-instance-creation

# Copy config
cp ~/.oci/config ./oci_config
cp ~/.oci/oci_api_key.pem ./oci_api_private_key.pem

# Interactive setup
echo ""
echo "Running setup..."
./setup_env.sh

echo ""
echo "Starting automatic retry script..."
echo "This will run until a free instance is created."
echo "Press Ctrl+C to stop."
echo ""

./setup_init.sh
