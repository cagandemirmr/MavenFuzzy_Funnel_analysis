# 📊 Maven Fuzzy Factory: Pazarlama Hunisi ve Veri Analizi Projesi

---
## Projenin Amacı

Bu proje, e-ticaret web sitesinin trafik kaynakları ve kullanıcı davranışları üzerinden pazarlama kampanyalarının verimliliğini ölçmek ve dönüşüm hunisindeki sorunlu noktaları belirlemek amacıyla yapılmıştır.

--- 

## 🎯 Hedef Kitle

Bu proje aşağıdaki kişiler/kurumlar için faydalıdır:

- **Dijital pazarlama uzmanları** (kampanya ROI hesaplama)
- **E-ticaretle uğraşanlar** (funnel optimizasyonu)
- **İş karar vericileri** (veriye dayalı yatırım kararları için)

---

## 🔮 İşletmenizde nasıl katkı sağlayabilirim

- Tableau ya da Power BI ile **etkileşimli gösterge paneli (dashboard)** geliştirme  
- Benzer e-ticaret veri setleri için yeniden kullanılabilir **SQL şablonları**  
- Yeni vs. geri dönen kullanıcı ayrımı ve coğrafi analiz ekleme  

---

## 📌 Problem Tanımı

Birçok şirket dijital reklamlara ciddi bütçeler ayırmakta, ancak:

- Hangi trafik kaynakları daha verimli?
- Kullanıcılar hangi adımlarda süreci terk ediyor?
- Organik trafik mi, yoksa reklamlar mı daha fazla dönüşüm sağlıyor?

Bu proje, [Maven Fuzzy Factory](https://www.mavenanalytics.io/data-playground) e-ticaret veri seti üzerinden bu sorulara yanıt aramak ve **kullanıcı davranışlarını analiz etmek** amacıyla gerçekleştirilmiştir.

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

## 🧠 Yaklaşımım

Proje, iki temel analiz adımıyla yapılandırıldı:

### 1️⃣ Keşifsel Veri Analizi (EDA)
#### Veri Keşfi ve Genel Bilgiler
- **website_pageviews** tablosunda 1.188.124 kayıt ve 4 sütun mevcut.
- Veri aralığı: **2012-03-19 08:04:16** - **2015-03-19 07:59:32**
- Toplam benzersiz oturum sayısı: **472.871**
- Toplam benzersiz sayfa URL sayısı: **16**

##### Önemli URL'ler:/billing, /cart, /home, /products, /thank-you-for-your-order

#### Website Oturumları (website_sessions)

- Toplam kayıt: **472.871**
- Veri aralığı: 2012-03-19 - 2015-03-19
- Benzersiz kullanıcı sayısı: **394.318**
- Tekrarlayan oturumlar: 2 farklı değer (0, 1)
- UTM kaynak sayısı: 4 (bsearch, socialbook, gsearch, NULL)


#### Reklam ve Organik Trafik Sınıflandırması:

Sosyal Medya mecralarına bağlı olarak sosyal medya ve organik olarak ikiye ayırdım.

```sql
ALTER TABLE website_sessions ADD is_content nvarchar(50);

UPDATE website_sessions
SET is_content = CASE 
    WHEN utm_campaign='NULL' AND utm_source IN ('NULL','socialbook') THEN 'content' 
    ELSE 'Ad' 
END;
```
##### Zaman Değişkenleri

-Yıl, ay ve saat bilgileri eklendi ve güncellendi:
```sql
ALTER TABLE website_sessions ADD year_ INT;
UPDATE website_sessions SET year_ = YEAR(created_at);

ALTER TABLE website_sessions ADD month_ INT;
UPDATE website_sessions SET month_ = MONTH(created_at);

ALTER TABLE website_sessions ADD time_ INT;
UPDATE website_sessions SET time_ = DATEPART(hour, created_at);
```
### Trafik Kaynakları ve Cihaz Dağılımı

**Cihaz türü dağılımı:**

![image](https://github.com/user-attachments/assets/dc8abba1-3a1d-440f-9e70-6cf62a4d2af0)


Masaüstü (desktop): 288.580 kullanıcı

Mobil (mobile): 133.839 kullanıcı

**Trafik kaynakları:**


gsearch: 299.700 kullanıcı

bsearch: 61.965 kullanıcı

socialbook: 10.685 kullanıcı

NULL: 66.144 kullanıcı (organik trafik)

**Reklam içeriği:**

![image](https://github.com/user-attachments/assets/5b0f7908-6fe0-414b-a1da-af5534123d8c)

g_ad_1, g_ad_2 (Google Ads)

b_ad_1, b_ad_2 (Bing Ads)

social_ad_1, social_ad_2 (Sosyal medya reklamları)

### Siparişler (orders)

![image](https://github.com/user-attachments/assets/35f8aaa5-71d0-4a74-991b-2ad07f941f2a)


- Toplam kayıt: 32.313
- **Toplam gelir (Total_Revenue)** hesaplandı:

```sql
ALTER TABLE orders ADD Total_Revenue INT;

UPDATE orders
SET Total_Revenue = price_usd * items_purchased;
```
- Sipariş verisi 24.601 satırda eksiksiz.

### Özet

- Veride eksik veri neredeyse yok, temiz ve sağlam bir veri seti.
- Trafik kaynakları ve cihaz türlerine göre kullanıcı davranışları net şekilde analiz edilebilir.
- Reklam kampanyalarının etkinliği kolayca takip edilebilir.
- Gelir hesaplamaları ve sipariş analizleri yapılabilir.


### 2️⃣ Huni Analizi (Funnel Analysis)
Bu analiz, kullanıcıların web sitesine ilk girişinden satın alma işlemine kadar olan dönüşüm sürecini incelemektedir. Aşağıdaki adımlar izlenmiştir:
- Kullanıcının web sitesindeki yolculuğu adım adım incelendi:  
  *Giriş → Sayfa Görüntüleme → Sepete Ekleme → Sipariş Verme*
- Dönüşüm oranları hesaplandı ve **tıkanıklık yaşanan noktalar** tespit edildi.

1. Kullanıcıların Siteye Gelişi
Toplamda 472.871 oturum (session) incelenmiştir. Bu oturumlar içerisinde 394.318 farklı kullanıcı, web sitesini ziyaret etmiştir.

```sql
SELECT COUNT(DISTINCT(user_id)) FROM website_sessions;
```

 2. Web Sitesiyle Etkileşime Girenler

Kullanıcıların /home, /products, /cart, /shipping, /billing gibi sayfalara ziyaretleri baz alınarak, 89.895 kişinin siparişi düşündüğü değerlendirilmiştir.

```sql
SELECT COUNT(DISTINCT s.user_id)
FROM website_pageviews v
JOIN website_sessions s ON s.website_session_id = v.website_session_id
WHERE v.pageview_url IN ('/home','/products','/cart','/shipping','/billing');
```
3. Sipariş Veren Kullanıcılar
Sipariş oluşturan kullanıcı sayısı: 31.696

Toplam sipariş sayısı: 32.313

```sql
SELECT COUNT(DISTINCT s.user_id)
FROM orders o
JOIN website_sessions s ON s.website_session_id = o.website_session_id;
```
 4. Satın Almayı Tamamlayan Kullanıcılar
İade işlemine girmemiş kullanıcılar göz önüne alındığında, 30.040 kişi başarılı bir şekilde satın alma işlemini tamamlamıştır.

```sql
SELECT COUNT(DISTINCT s.user_id)
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN website_sessions s ON s.website_session_id = o.website_session_id
LEFT JOIN order_item_refunds re ON re.order_id = o.order_id
WHERE re.order_item_refund_id IS NULL;
```
**Dönüşüm Oranları**

- Kullanıcıların siteye girişten satın alma sürecine kadar olan oranları hesaplanmıştır:

- Sayfa etkileşim oranı: % Page_interaction_percentage

- Sipariş verme oranı: % Orders_percentage

- Satın alma oranı: % Purchased_percentage

```sql
SELECT 
    100.0 * SUM(q2.page_) / NULLIF(SUM(q1.ws_ses), 0) AS Page_interaction_percentage,
    100.0 * SUM(q3.orders) / NULLIF(SUM(q2.page_), 0) AS Orders_percentage,
    100.0 * SUM(q4.purchased) / NULLIF(SUM(q3.orders), 0) AS Purchased_percentage
FROM ...
```

**Reklamdan Gelen Kullanıcıların Dönüşümü**
```sql
SELECT COUNT(DISTINCT s.user_id)
FROM website_sessions s
JOIN website_pageviews v ON s.website_session_id = v.website_session_id
WHERE v.pageview_url IN ('/lander-1','/lander-2','/lander-3','/lander-4','/lander-5')
AND s.user_id IN (
    SELECT DISTINCT s2.user_id
    FROM website_sessions s2
    JOIN website_pageviews v2 ON s2.website_session_id = v2.website_session_id
    WHERE v2.pageview_url IN ('/cart','/billing','/shipping')
);
```

## 💡 Elde Edilen Bulgular

![image](https://github.com/user-attachments/assets/665d56f7-d0f7-48e0-94b5-3eba3f425cf1)


- **Organik trafik**, en yüksek dönüşüm oranına sahip ve maliyetsiz.
- **Dönüşüm oranı düşük** ,	Sayfa etkileşimi yüksek ama satın alma düşük → nedenleri analiz edilmeli (ör. ödeme süreci, güven problemi, yavaş site)
- **Masaüstü cihazlar**, mobil ve tabletlere göre daha başarılı dönüşümler sağlıyor.
- **Organic ve sosyal trafik düşük**	SEO stratejisi, sosyal medya kampanyaları artırılmalı.
- **Mobil kullanıcı az**	Site mobil deneyimi A/B testiyle iyileştirilebilir.
- **b_ad reklamları** en verimli kaynak; **sosyal medya reklamları** düşük performans gösteriyor.
- **Sepete ekleme → sipariş** adımında en fazla kullanıcı kaybı yaşanıyor.


---
## Veriye Dayalı Alınabilecek Kararlar

- b_ad reklamları daha verimli çalıştığı için bütçenin bu alana kaydırılması önerilir.

- Mobilde dönüşüm düşükse, mobil arayüzde iyileştirme yapılabilir.

- Sepet aşamasındaki kayıp nedeniyle ücretsiz kargo gibi teşvikler denenebilir.

---
 ## Motivasyon ve Katkılarım
Bu proje, yalnızca temel istatistiksel analizler sunmanın ötesinde, veriyle düşünme becerimi, sunum yeteneğimi ve uçtan uca proje yönetimi yapabilme kapasitemi ortaya koymak amacıyla hazırlanmıştır.

Veri ön işleme, eksik verilerin yönetimi, kategorik sınıflandırmalar (örneğin yaş aralıkları gibi), pivot tablolarla içgörü çıkarımı ve görsel sunum gibi pek çok adımı kendi başıma gerçekleştirdim.

### Bu projede öne çıkan bazı katkılarım:
**Veri Temizliği ve Yapılandırma:** Ham veriyi anlamlı hale getirdim; yaş aralıkları oluşturdum ve kullanıcı davranışlarını daha iyi analiz edebileceğimiz biçime soktum.

**Karar Destek Perspektifi:** Sadece analiz değil, iş kararları için nasıl kullanılabileceğini göstermek adına raporlama araçlarını kullanarak görsel özetler sundum.

**Sunum ve Anlatım:** Projeyi görselleştirdim ve hem sessiz hem de anlatımlı YouTube videoları oluşturarak, farklı izleyici kitlelerine hitap etmeye çalıştım.

**Girişimcilik ve Öz-Yönelim:** Projeyi kendi inisiyatifimle planladım, uyguladım ve yayına aldım. Bu tür bireysel üretim süreçleri freelance işler için çok değerlidir.

### Neden Basit Gibi Görünse de Değerli?
Basit görünen analizleri etkili şekilde planlamak, doğru veri görselleştirme tekniklerini seçmek ve tüm süreci net biçimde sunabilmek; işverenlerin, müşterilerin ve teknik ekiplerin değer verdiği becerilerdir. Bu proje, bu yetenekleri geliştirme ve gösterme hedefiyle hazırlanmıştır.

---

## 🛠️ Kullanılan Teknolojiler

- **SQL** (PostgreSQL dili)  
- **Git** (versiyon kontrolü için)  
- **Maven Fuzzy Factory Dataset** (gerçekçi e-ticaret örnek verisi)

---


## 📂 Teslim Edilen Dosyalar

| Dosya Adı | Açıklama |
|-----------|----------|
| `EDA.sql` | Trafik analizi, cihaz kırılımı, genel istatistikler |
| `Funnel_Analysis.sql` | Huni adımları, dönüşüm oranları, kampanya performansları |

> İsteğe bağlı olarak: PDF rapor, görsel grafikler veya Tableau/PBI dashboard eklenebilir.

---



## 📞 İletişim

LinkedIn: [www.linkedin.com/in/cagan-demir]  

Mail: [cagandemirmr@gmail.com]


---





