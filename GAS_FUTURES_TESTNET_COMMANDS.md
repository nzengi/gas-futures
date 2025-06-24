# Gas Futures Testnet Komutları ve Objeleri

## Paket ve Modül Bilgileri

- **Package ID:**  
  `0x5464e044ddd3a09da8b4648fb88eef92effd147f15a68f4705cd27360fdedc27`

---

## Kullanılacak Objeler

| Amaç            | Object ID                                                            | Tipi / Açıklama                            |
| --------------- | -------------------------------------------------------------------- | ------------------------------------------ |
| RiskPool        | `0xc74d8afccd894d602240c119ddfe79a8a34cc886383623c6558e0fb4bced7a60` | Shared RiskPool (collateral: 150M MIST)    |
| GasOracle       | `0x9637f6c658ab3409883a9f12020cd9a860900d8bf9e88eca711f3f82a1527da8` | Owned GasOracle (fallback_price: 1000)     |
| EmergencySwitch | `0xf2dadef686e3add4279aab7eeebc7339adb6e22a26f3ce95d526c66f0480b13e` | Owned EmergencySwitch                      |
| PricingModel    | `0xa6972adecdd2dde331b2874868b500a30c2794932bdf545c9d47498778186cb6` | Owned PricingModel (vol: 50%, rate: 25bps) |
| GasFutureToken  | `0xda546ee77bcd95086ad24704e326f24fd8ed30de45caa2d85ccdfc1dc9587696` | Owned Token (100 gas units, strike: 1100)  |
| SUI Coin        | `0x27f72b7f1d16958aa9f27c63f61483b2834759d34f9395db3736df19f8ef34cd` | Owned SUI Coin (gas payment için)          |

---

## ✅ Başarılı Test Sonuçları

### **1. RiskPool Deposit** ✅

- **Transaction:** `HRzjkozHpnma3EfBgfn9uz3dsPVBtQkuXCFMnN2egw92`
- **Amount:** 100,000,000 MIST
- **Status:** Başarılı

### **2. Token Mint** ✅

- **Transaction:** `5g4QvrCuvBci1rBJ6FN6jVeZT1zDKJNXDDKFX6HhqnSV`
- **Token ID:** `0xda546ee77bcd95086ad24704e326f24fd8ed30de45caa2d85ccdfc1dc9587696`
- **Gas Units:** 100
- **Strike Price:** 1100 MIST
- **Premium Paid:** 0 MIST
- **Expiry:** 1728000000 (20 gün sonra)
- **Status:** Başarılı

---

## Test Komutları

### 1. **RiskPool'a Deposit Yapma**

```sh
sui client call \
  --package 0x5464e044ddd3a09da8b4648fb88eef92effd147f15a68f4705cd27360fdedc27 \
  --module risk_pool \
  --function deposit \
  --args 0xc74d8afccd894d602240c119ddfe79a8a34cc886383623c6558e0fb4bced7a60 <COIN_ID> 0xf2dadef686e3add4279aab7eeebc7339adb6e22a26f3ce95d526c66f0480b13e \
  --gas 0x27f72b7f1d16958aa9f27c63f61483b2834759d34f9395db3736df19f8ef34cd \
  --gas-budget 5000000
```

### 2. **Token Mint Etme**

```sh
sui client call \
  --package 0x5464e044ddd3a09da8b4648fb88eef92effd147f15a68f4705cd27360fdedc27 \
  --module futures_token \
  --function mint \
  --args 0xc74d8afccd894d602240c119ddfe79a8a34cc886383623c6558e0fb4bced7a60 0x9637f6c658ab3409883a9f12020cd9a860900d8bf9e88eca711f3f82a1527da8 0xa6972adecdd2dde331b2874868b500a30c2794932bdf545c9d47498778186cb6 0xf2dadef686e3add4279aab7eeebc7339adb6e22a26f3ce95d526c66f0480b13e 100 1728000000 <PAYMENT_COIN_ID> \
  --gas 0x27f72b7f1d16958aa9f27c63f61483b2834759d34f9395db3736df19f8ef34cd \
  --gas-budget 10000000
```

**Parametreler:**

- `gas_units`: 100 (mint edilecek gaz birimi)
- `expiry`: 1728000000 (20 gün sonra, Unix timestamp)

### 3. **Emergency Switch Kontrolü**

```sh
sui client call \
  --package 0x5464e044ddd3a09da8b4648fb88eef92effd147f15a68f4705cd27360fdedc27 \
  --module emergency \
  --function pause_contract \
  --args 0xf2dadef686e3add4279aab7eeebc7339adb6e22a26f3ce95d526c66f0480b13e \
  --gas 0x27f72b7f1d16958aa9f27c63f61483b2834759d34f9395db3736df19f8ef34cd \
  --gas-budget 1000000
```

### 4. **Risk Pool Durumu Kontrolü**

```sh
sui client object 0xc74d8afccd894d602240c119ddfe79a8a34cc886383623c6558e0fb4bced7a60
```

### 5. **Token Durumu Kontrolü**

```sh
sui client object 0xda546ee77bcd95086ad24704e326f24fd8ed30de45caa2d85ccdfc1dc9587696
```

---

## Obje Oluşturma Komutları

### **Yeni EmergencySwitch Oluşturma**

```sh
sui client call \
  --package 0x5464e044ddd3a09da8b4648fb88eef92effd147f15a68f4705cd27360fdedc27 \
  --module emergency \
  --function create_emergency_switch \
  --gas-budget 5000000
```

### **Yeni GasOracle Oluşturma**

```sh
sui client call \
  --package 0x5464e044ddd3a09da8b4648fb88eef92effd147f15a68f4705cd27360fdedc27 \
  --module oracle_integration \
  --function create_gas_oracle \
  --args 1000 \
  --gas-budget 5000000
```

### **Yeni PricingModel Oluşturma**

```sh
sui client call \
  --package 0x5464e044ddd3a09da8b4648fb88eef92effd147f15a68f4705cd27360fdedc27 \
  --module pricing \
  --function create_pricing_model \
  --args 50 25 \
  --gas-budget 5000000
```

---

## Önemli Notlar

1. **Gas Budget**: Tüm işlemler için minimum 1,000,000 MIST gas budget gerekli
2. **Coin Kullanımı**: Aynı coin hem gas payment hem de ödeme için kullanılamaz
3. **EmergencySwitch**: Her işlemden sonra hesabınıza geri döner
4. **RiskPool**: Shared object olduğu için herkes tarafından kullanılabilir
5. **Token Expiry**: Unix timestamp formatında (saniye cinsinden)
6. **Risk Pool Durumu**: 150M MIST collateral, 0 liabilities

---

## Test Senaryoları

### **✅ Senaryo 1: Temel Token Mint** (TAMAMLANDI)

1. ✅ RiskPool'a deposit yap
2. ✅ Token mint et
3. ✅ Token'ın oluşturulduğunu kontrol et

### **Senaryo 2: Emergency Switch Test**

1. Emergency switch'i pause et
2. Token mint etmeye çalış (hata almalı)
3. Emergency switch'i resume et
4. Token mint et (başarılı olmalı)

### **Senaryo 3: Risk Pool Yeterlilik**

1. Büyük miktarda token mint et
2. Risk pool'un yeterliliğini kontrol et
3. Limit aşıldığında hata al

---

## Hata Kodları

- `E_INSUFFICIENT_PAYMENT`: Yetersiz ödeme
- `E_CONTRACT_PAUSED`: Kontrat duraklatılmış
- `E_TOKEN_EXPIRED`: Token süresi dolmuş
- `E_INSUFFICIENT_COLLATERAL`: Yetersiz teminat
