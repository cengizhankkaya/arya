# Güvenlik İyileştirmeleri

Bu dokümanda, Arya uygulamasında yapılan güvenlik iyileştirmeleri detaylandırılmıştır.

## 1. Input Validation (Girdi Doğrulama)

### Username Validasyonu
- **Minimum uzunluk**: 3 karakter
- **Maksimum uzunluk**: 50 karakter
- **Karakter kısıtlaması**: Sadece alfanumerik karakterler ve alt çizgi (`[a-zA-Z0-9_]`)
- **Boş değer kontrolü**: Username boş olamaz

### Password Validasyonu
- **Minimum uzunluk**: 8 karakter
- **Maksimum uzunluk**: 128 karakter
- **Güçlü şifre gereksinimleri**:
  - En az bir büyük harf (`[A-Z]`)
  - En az bir küçük harf (`[a-z]`)
  - En az bir rakam (`[0-9]`)
  - En az bir özel karakter (`[!@#$%^&*(),.?":{}|<>]`)

### Güvenlik Kuralları
- Username ve password aynı olamaz
- Username password içinde geçemez
- Corrupted data tespit edildiğinde otomatik temizleme

## 2. Input Sanitization (Girdi Temizleme)

### HTML/JavaScript Temizleme
- HTML tag'leri kaldırma (`<[^>]*>`)
- JavaScript protokolü engelleme (`javascript:`)
- Data URI engelleme (`data:`)
- VBScript engelleme (`vbscript:`)

### SQL Injection Önleme
- Tek tırnak escape (`'` → `''`)
- Çift tırnak escape (`"` → `""`)

### XSS Koruması
- Script tag'leri temizleme
- Event handler'ları engelleme
- Malicious URL'leri filtreleme

## 3. API Security (API Güvenliği)

### Rate Limiting
- **ViewModel seviyesi**: 5 kaydetme denemesi / 1 dakika
- **Service seviyesi**: 30 istek / 1 dakika / operasyon
- **Cooldown süresi**: 1 dakika
- **Otomatik reset**: Cooldown süresi sonunda

### Hata Mesajları
- **Production**: Generic hata mesajları (sensitive bilgi sızıntısı yok)
- **Development**: Detaylı hata mesajları (debug için)
- **Güvenli loglama**: Environment-based hata detayları

## 4. Katmanlı Güvenlik

### ViewModel Katmanı
- UI input validation
- Rate limiting kontrolü
- Input sanitization
- Güvenli hata işleme

### Repository Katmanı
- Ek validasyon kontrolü
- Corrupted data tespiti
- Güvenlik kuralları kontrolü
- Repository seviyesinde hata loglama

### Service Katmanı
- Core business logic validasyonu
- Rate limiting implementasyonu
- Güvenlik gereksinimleri kontrolü
- Service seviyesinde hata loglama

## 5. Güvenlik Özellikleri

### Otomatik Temizleme
- Corrupted credentials tespit edildiğinde otomatik silme
- Invalid data format'ında otomatik temizleme
- Security violation'da otomatik block

### Monitoring ve Logging
- Rate limit violation loglama
- Security violation tracking
- Environment-based log seviyeleri
- Production-safe error handling

## 6. Kullanım Örnekleri

### Rate Limiting Kontrolü
```dart
if (viewModel.isRateLimited) {
  // Rate limit exceeded
  showError(context, 'off.rate_limit_exceeded'.tr());
  return;
}
```

### Güvenlik Durumu Kontrolü
```dart
if (!viewModel.isFormValid) {
  // Form validation failed
  return;
}
```

### Kalan Deneme Sayısı
```dart
final remaining = viewModel.remainingAttempts;
showInfo(context, 'Kalan deneme: $remaining');
```

## 7. Test Senaryoları

### Input Validation Testleri
- [ ] Boş username/password
- [ ] Çok kısa username/password
- [ ] Çok uzun username/password
- [ ] Geçersiz karakterler
- [ ] Weak password

### Security Testleri
- [ ] Username = Password
- [ ] Username in Password
- [ ] HTML injection
- [ ] JavaScript injection
- [ ] SQL injection

### Rate Limiting Testleri
- [ ] Normal kullanım
- [ ] Rate limit exceeded
- [ ] Cooldown süresi
- [ ] Reset functionality

## 8. Gelecek İyileştirmeler

### Planlanan Özellikler
- [ ] Biometric authentication
- [ ] Encryption at rest
- [ ] Secure key storage
- [ ] Certificate pinning
- [ ] Network security policies

### Monitoring
- [ ] Security metrics
- [ ] Anomaly detection
- [ ] Real-time alerts
- [ ] Security dashboard

---

**Not**: Bu güvenlik iyileştirmeleri, OWASP Top 10 ve Flutter security best practices'e uygun olarak tasarlanmıştır.
