#!/bin/bash
# Gas Futures Testnet Deploy Script
# Bu script gas futures projesini testnet'e deploy etmek için kullanılacak

echo "🚀 Gas Futures Testnet Deploy Script"
echo "===================================="

# Aktif network kontrolü
echo "📡 Aktif Network Kontrolü..."
CURRENT_NETWORK=$(sui client active-env)
echo "Aktif Network: $CURRENT_NETWORK"

# Hesap kontrolü
echo "👤 Hesap Kontrolü..."
ACTIVE_ADDRESS=$(sui client active-address)
echo "Aktif Adres: $ACTIVE_ADDRESS"

# Bakiye kontrolü
echo "💰 Bakiye Kontrolü..."
sui client balance

# Build işlemi
echo "🔨 Build İşlemi..."
sui move build

# Deploy işlemi
echo "📦 Deploy İşlemi..."
sui client publish --gas-budget 10000000

echo "✅ Deploy tamamlandı!"
echo "📋 Kontrat adresleri yukarıda listelenmiştir."
