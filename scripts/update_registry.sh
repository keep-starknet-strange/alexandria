#!/bin/bash

# Yayınlanacak paket isimleri (sıralı)
packages=(
  alexandria_data_structures
  alexandria_ascii
  alexandria_math
  alexandria_linalg
  alexandria_macros
  alexandria_utils
  alexandria_storage
  alexandria_sorting
  alexandria_searching
  alexandria_numeric
  alexandria_merkle_tree
  alexandria_bytes
  alexandria_encoding
  # buraya diğer paketleri ekleyebilirsin
)

# Her paket için sırayla yayınlama komutu çalıştır
for package in "${packages[@]}"; do
  echo "Publishing package: $package"
  scarb publish --package "$package"

  # Hata kontrolü (bir paket başarısız olursa işlemi durdur)
  if [ $? -ne 0 ]; then
    echo "Error publishing package: $package"
    exit 1
  fi
done

echo "All packages published successfully."