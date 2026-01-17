# Flutter Yemek Tarifi Uygulaması

Bu uygulama Flutter ile geliştirilmiş basit bir yemek tarifi uygulamasıdır.  
Uygulama; hazır tarifleri dış bir API üzerinden görüntüleyebilir,  
kullanıcının kendi tariflerini ekleyip silebilir  
ve favori tarifleri **lokal veritabanında kalıcı** olarak saklar.

---

## Demo Videosu
https://drive.google.com/file/d/1_GVxSCExG17vtgirQ4CEDIgHbmYfx4xt/view?usp=sharing


## Özellikler

- API üzerinden yemek arama  
- Tarif detaylarını görüntüleme  
- Favorilere ekleme / çıkarma  
- SQLite üzerinden kalıcı veri saklama
- Kendi tarifini ekleme/silme
- Swagger (OpenAPI) destekli backend dokümantasyonu 

  
---

##  Ekranlar

- **Home Page:** Rastgele yemek tariflerin gösterildiği sayfa
- **Favorites Page:** Kaydedilmiş favori tariflerin olduğu sayfa  
- **Detail Page:** Yemeğin detayları, malzemeler ve açıklamalarının olduğu sayfa  
- **User Recipe Page::** Kullanıcının kendi eklediği tariflerin olduğu sayfa

---

## Kullanılan Teknolojiler

- Flutter  
- Dart  
- SQLite (sqflite)  
- sqflite_common_ffi  
- Provider (State Management)  
- TheMealDB API
- Python
- Flask
- Flask-RESTX (Swagger)
- Flask-CORS

---
## Swagger (API Dokümantasyonu)

Backend API, **Swagger (OpenAPI)** desteği ile birlikte gelir.  
Swagger arayüzü sayesinde tüm endpoint’ler, parametreler ve response yapıları tarayıcı üzerinden görüntülenebilir ve test edilebilir.

Backend çalışır durumdayken Swagger arayüzüne şu adresten erişilebilir:

```text
http://localhost:5050/docs
```
---
  
## Backend Kurulumu
Bu proje, geliştirme sürecinde Flask tabanlı bir backend API kullanır.
- TheMealDB API için proxy görevi görür.
- Kullanıcı tarifleri için in-memory veri
- Swagger (OpenAPI) dokümantasyonu sunar

### Backend Kurulumu
```
pip install -r requirements.txt
```

### Backend’i çalıştırmak için:
```
python main.py
```



---


##  Kurulum ve Çalıştırma

### 1) Bağımlılıkları yükle
```
flutter pub get
```

### 2) Uygulamayı başlat
```
flutter run
```

### 3) Desktop ortamında çalıştırmak için:
```dart
sqfliteFfiInit();
databaseFactory = databaseFactoryFfi;
```

---

## API Kullanımı
Uygulama, TheMealDB API’yi doğrudan kullanmak yerine  
**Flask tabanlı bir API** üzerinden erişim sağlar.

