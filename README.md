# 📊 Maven Fuzzy Factory: Pazarlama Hunisi ve Veri Analizi Projesi

## 📌 Problem Tanımı

Birçok şirket dijital reklamlara ciddi bütçeler ayırmakta, ancak:

- Hangi trafik kaynakları daha verimli?
- Kullanıcılar hangi adımlarda süreci terk ediyor?
- Organik trafik mi, yoksa reklamlar mı daha fazla dönüşüm sağlıyor?

Bu proje, [Maven Fuzzy Factory](https://www.mavenanalytics.io/data-playground) e-ticaret veri seti üzerinden bu sorulara yanıt aramak ve **kullanıcı davranışlarını analiz etmek** amacıyla gerçekleştirilmiştir.

---

## 🧠 Yaklaşımım

Proje, iki temel analiz adımıyla yapılandırıldı:

### 1️⃣ Keşifsel Veri Analizi (EDA)
- Trafik kaynakları, cihaz türleri ve oturum kalitesi incelendi.
- `session_id`, `utm_source`, `device` gibi değişkenler temizlenip kategorilere ayrıldı.

### 2️⃣ Huni Analizi (Funnel Analysis)
- Kullanıcının web sitesindeki yolculuğu adım adım incelendi:  
  *Giriş → Sayfa Görüntüleme → Sepete Ekleme → Sipariş Verme*
- Dönüşüm oranları hesaplandı ve **tıkanıklık yaşanan noktalar** tespit edildi.

---

## 🛠️ Kullanılan Teknolojiler

- **SQL** (PostgreSQL dili)  
- **Git** (versiyon kontrolü için)  
- **Maven Fuzzy Factory Dataset** (gerçekçi e-ticaret örnek verisi)

---

## 🔍 Analiz Aşamaları

### 📌 EDA (Keşifsel Veri Analizi)
- Organik vs. reklam kaynaklı trafik ayrımı
- Cihaz kırılımı: masaüstü, mobil, tablet
- Hangi kaynaklar daha çok oturum getiriyor?

### 📌 Huni Analizi (Funnel Analysis)
- Sayfa → Sipariş adımları arasında kullanıcı kayıpları
- Trafik kaynaklarına göre dönüşüm oranları
- En verimli reklam kampanyalarının tespiti

---

## 💡 Elde Edilen Bulgular

- **Organik trafik**, en yüksek dönüşüm oranına sahip ve maliyetsiz.
- **Masaüstü cihazlar**, mobil ve tabletlere göre daha başarılı dönüşümler sağlıyor.
- **b_ad reklamları** en verimli kaynak; **sosyal medya reklamları** düşük performans gösteriyor.
- **Sepete ekleme → sipariş** adımında en fazla kullanıcı kaybı yaşanıyor.

---

## 📂 Teslim Edilen Dosyalar

| Dosya Adı | Açıklama |
|-----------|----------|
| `EDA.sql` | Trafik analizi, cihaz kırılımı, genel istatistikler |
| `Funnel_Analysis.sql` | Huni adımları, dönüşüm oranları, kampanya performansları |

> İsteğe bağlı olarak: PDF rapor, görsel grafikler veya Tableau/PBI dashboard eklenebilir.

---

## 🎯 Hedef Kitle

Bu proje aşağıdaki kişiler/kurumlar için faydalıdır:

- **Dijital pazarlama uzmanları** (kampanya ROI hesaplama)
- **E-ticaret analistleri** (funnel optimizasyonu)
- **İş karar vericiler** (veriye dayalı yatırım kararları için)

---

## 🔮 Gelecek Geliştirmeler

- Tableau ya da Power BI ile **etkileşimli gösterge paneli (dashboard)** geliştirme  
- Benzer e-ticaret veri setleri için yeniden kullanılabilir **SQL şablonları**  
- Yeni vs. geri dönen kullanıcı ayrımı ve coğrafi analiz ekleme  

---

## 📞 İletişim

LinkedIn: [www.linkedin.com/in/cagan-demir]  


---

## 🏷️ Etiketler

`#SQL` `#VeriAnalizi` `#HuniAnalizi` `#EDA` `#DijitalPazarlama` `#E-Ticaret`

---

