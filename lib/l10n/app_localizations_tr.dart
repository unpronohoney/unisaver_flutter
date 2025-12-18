// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get main_welcome => 'Hoşgeldiniz';

  @override
  String get main_btns1 => 'Manuel Agno Hesabı';

  @override
  String get main_btns2 => 'Kombinasyonlu Agno Hesabı';

  @override
  String get main_btns3 => 'Transkript ile Agno Hesabı';

  @override
  String get main_head1 => 'Lütfen işlem seçiniz:';

  @override
  String get main_head2 => 'Gizlilik Politikası';

  @override
  String get main_head3 => 'Geri Bildirim Silme Talebi';

  @override
  String get menu1 => 'Harf Notlarını Özelleştir';

  @override
  String get menu2 => 'Dil - Türkçe';

  @override
  String get menu3 => 'Bize Ulaşın';

  @override
  String lecture_subtitle(Object cred, Object newletter, Object oldletter) {
    return 'Kredi: $cred\nNot: $oldletter → $newletter';
  }

  @override
  String lecture_subtitle_com(Object cred, Object oldletter) {
    return 'Kredi: $cred Not: $oldletter';
  }

  @override
  String get edit_lecture => 'Ders Düzenle';

  @override
  String get save => 'Kaydet';

  @override
  String get new_letter => 'Yeni Harf Notu';

  @override
  String get old_letter => 'Eski Harf Notu';

  @override
  String get credit => 'Kredi';

  @override
  String get letter_grade => 'Harf Notu';

  @override
  String lecture_card(Object cred, Object letter) {
    return 'Kredi/Not: $cred/$letter';
  }

  @override
  String lecture_info(Object cred, Object letter, Object name, Object no) {
    return '$no. $name\nKr/N: $cred/$letter';
  }

  @override
  String get hardest => 'En Zor';

  @override
  String get hard => 'Zor';

  @override
  String get medium => 'Orta';

  @override
  String get easy => 'Kolay';

  @override
  String get easiest => 'En Kolay';

  @override
  String get whats_difficulties => 'Zorluk Seviyelerinin Anlamı Nedir?';

  @override
  String get hardest_info => 'En zor dersler: Yoğun, yüksek emek';

  @override
  String get hard_info => 'Zor dersler: Zorlayıcı';

  @override
  String get medium_info => 'Orta dersler: Dengeli';

  @override
  String get easy_info => 'Kolay dersler: Rahat';

  @override
  String get easiest_info => 'En kolay dersler: Hafif konular';

  @override
  String get how_use_diffs =>
      'Derslerin zorluk seviyelerini uzun basıp sürükleyerek değiştir.';

  @override
  String get min_gpa => 'Min AGNO';

  @override
  String get max_gpa => 'Maks AGNO';

  @override
  String get constraints_title => 'Kısıtlar Ne Yapıyor?';

  @override
  String get constraints_description =>
      'Şu kısıtları kullanarak tüm olası kombinasyon sayısını azaltabilirsiniz:';

  @override
  String get first_constraint => 'Min/Maks AGNO\'lar';

  @override
  String get first_const_desc =>
      'Kombinasyonların uyması gereken bir AGNO aralığı belirleyin.';

  @override
  String get second_constraint => 'Min/Maks Harf Notu';

  @override
  String get second_const_desc =>
      'Kombinasyon derslerinin uyması gereken not aralığını belirleyin.';

  @override
  String get third_constraint => 'Kombinasyon Genişliği Limiti';

  @override
  String get third_const_desc =>
      'Bu değer, aynı AGNO\'lara sahip olabilecek kaç kombinasyon olacağını belirler.';

  @override
  String get fourt_constraint => 'AGNO Bölücü';

  @override
  String get fourth_const_desc =>
      'Varsayılan değeri 0.01. AGNO\'su bu değere tam bölünemeyen kombinasyonlar elenir.';

  @override
  String get min_letter => 'Min Harf';

  @override
  String get max_letter => 'Maks Harf';

  @override
  String get select => 'Seç';

  @override
  String get apply_constraints => 'Kısıtları Uygula';

  @override
  String get show_combs => 'Kombinasyonlara Git';

  @override
  String get tot_cred => 'Toplam Kredi';

  @override
  String get details => 'Detayları Göster';

  @override
  String get select_gpa => 'Yukarıdan bir AGNO seç';

  @override
  String get selected_gpa => 'Seçilen AGNO';

  @override
  String get oldl => 'Eski';

  @override
  String get newl => 'Yeni';

  @override
  String get effect => 'Etki';

  @override
  String get comb_count => 'Kombinasyon Sayısı';

  @override
  String get lesson => 'Ders';

  @override
  String get initial => 'Baş';

  @override
  String get diff => 'Fark';

  @override
  String get result => 'Sonuç';

  @override
  String get term => 'Dönem';

  @override
  String get gpa_column => 'AGNO';

  @override
  String get currentAgno => 'Mevcut AGNO(GNO) notu';

  @override
  String get totalCred2 => 'Güncel toplam kredi sayısı';

  @override
  String get butPassAdding => 'Ders Girişine Geç';

  @override
  String agno_cred(Object credits, Object gpa) {
    return 'AGNO(GNO): $gpa Kredi: $credits';
  }

  @override
  String get manuel_5 => 'Dersin adı';

  @override
  String get lecCred => 'Dersin kredisi';

  @override
  String get oldletterinfo => 'Eski harf notu:';

  @override
  String get newletterinfo => 'Yeni harf notu:';

  @override
  String get butAddLec => 'Dersi Ekle';

  @override
  String get yok => 'Yok';

  @override
  String get ok => 'Bitir';

  @override
  String derssayar(Object count) {
    return '$count ders girdiniz.';
  }

  @override
  String get kisitlar => 'Hesaplama Kısıtları';

  @override
  String get refresh => 'Yenile';

  @override
  String get doc_cannot_read => 'Belge okunamadı…';

  @override
  String get doc_not_from_egov => 'Belge E-Devlet transkripti değil.';

  @override
  String get trans_btn => 'Transkripti Seç';

  @override
  String get error_occured => 'Bir hata meydana geldi.';

  @override
  String get select_letters => 'Harf Notlarını Seç!';

  @override
  String get gpa_overflow => 'AGNO Taşması!';

  @override
  String gpa_overflow_desc(Object range) {
    return 'AGNO\'n şu aralıkta olmalı: $range';
  }

  @override
  String get attention_edevlet =>
      'E-Devlet transkripti seçmeye dikkat et, henüz diğer transkriptleri okuyamıyorum. 😇';

  @override
  String credits(Object totcred) {
    return 'Kredi: $totcred';
  }

  @override
  String get uni_grades_head => 'Notlar ve Karşılıkları';

  @override
  String get uni_grades =>
      'AGNO\'nuz bu not haritası ile hesaplanmıştır. Sola kaydırarak başlangıçta transkriptinizde kullanılmamış gereksiz harf notlarını silebilirsiniz.';

  @override
  String get trans_mismatch => 'Uyumsuzluk Var! 🤥';

  @override
  String written_trans(Object temp) {
    return 'Transkriptte yazan $temp: ';
  }

  @override
  String i_calculated(Object temp) {
    return 'Hesapladığım $temp: ';
  }

  @override
  String get changes_will_calc => 'Değişikliklerin şunun ile hesaplanacak: ';

  @override
  String get and => 'AYRICA';

  @override
  String get degermi =>
      'UniSaver hakkındaki fikirleriniz bizim için çok değerlidir. Lütfen tüm görüşlerinizi belirtin.';

  @override
  String get degerlendirButton => 'Değerlendir';

  @override
  String get basaAl => 'Başa Al';

  @override
  String get silmeyiGeriAl => 'Silmeyi Geri Al';

  @override
  String get no_internet => 'İnternet bağlantısı yok.';

  @override
  String get timeout_error => 'İstek zaman aşımına uğradı.';

  @override
  String get light_mode => 'Açık Mod';

  @override
  String get dark_mode => 'Koyu Mod';

  @override
  String get noti_permission => 'Bildirim İzni';

  @override
  String get noti_permission_desc =>
      'Bildirimleri açmak için uygulama ayarlarına gitmen gerekiyor.';

  @override
  String get settings => 'Ayarlar';

  @override
  String get add_letter_grade => 'Harf Notunu Ekle';

  @override
  String get range_err => 'Kısıtlı değer aralığı!';

  @override
  String get range_err_desc =>
      'Harf dizisi en az 2 farklı not değerine sahip olmalı.';

  @override
  String get array_name => 'Harf Dizisi İsmi';

  @override
  String get letter => 'Harf';

  @override
  String get arrays_desc =>
      'Default diziyi düzenleyemezsin. Kişisel dizi istiyorsan, yenisini oluştur.';

  @override
  String get new_lett_array => 'Yeni Harf Dizisi';

  @override
  String get delete_warn => 'Silinsin mi?';

  @override
  String delete_warn_desc(Object arr_name) {
    return '$arr_name dizisini silmek istiyor musun?';
  }

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get link_not_opened => 'The link could not be opened...';

  @override
  String get link_n_opened_desc =>
      'The email address for feedback has not been created.';

  @override
  String get act_3_head3 =>
      'Eğer hatanızı transkript ile hesaplamada yaşadıysanız, lütfen transkriptinizi de ekleyiniz.';

  @override
  String get fb_subject => 'Konu';

  @override
  String get fb_desc => 'Açıklama';

  @override
  String get send => 'Gönder';

  @override
  String get feedback_info => 'Geri bildiriminiz başarıyla gönderildi.';

  @override
  String get feedback_error => 'Geri bildiriminiz gönderilemedi…';

  @override
  String get aimOfProject =>
      'UniSaver; üniversite puanları hesaplamanıza hızlı ve anlaşılır bir yol olabilmek için tasarlanmıştır.\nBu uygulamada yapabileceğiniz işlemler:\n';

  @override
  String get info_head1 => '1. Manuel agno Hesabı:';

  @override
  String get info_head2 => '2. Kombinasyonlu agno Hesabı:';

  @override
  String get info_head3 => '3. Transkript belgesi ile agno hesabı:';

  @override
  String get info_head4 => '4. Harf notu özelleştirmesi:';

  @override
  String get head1_exp => 'Derslerinizi manuel olarak girerek AGNO hesaplayın.';

  @override
  String get head2_exp =>
      'Dönemdeki tüm derslerinizi girin, sonra zorluklarına göre sıralayın, kısıtları belirleyin sonrasında olası tüm kombinasyonları görüntüleyebilirsiniz.';

  @override
  String get head3_exp =>
      'E-Devlet\'ten aldığınız (.pdf uzantılı) transkript belgeniz ile işlemleri rahatça yapabilirsiniz.\nÖzel bilgileriniz bu işlemde asla bize iletilmemektedir.';

  @override
  String get head4_exp =>
      '1 ve 2 numaralı işlemlerde kullanabileceğiniz harf notu dizilerini özelleştirebileceğiniz ekrana ana sayfadaki sağ üst menüden ulaşabilirsiniz.';

  @override
  String get tmm => 'Tamam';

  @override
  String get comb_copied => 'Kombinasyon kopyalandı.';

  @override
  String get giveAdvise => 'UniSaver nasıl kullanılır?';

  @override
  String get first_step => 'Şu bilgileri alsam...';

  @override
  String get difficulties => 'Derslerin zorluklarını sırala:';

  @override
  String get tot_comb_title => 'Toplam kombinasyon sayısı:';

  @override
  String get dersEkleyebilirsin => 've dersler';

  @override
  String get trans_title => 'Önce transkriptini okumam lazım...';

  @override
  String get playPuanla => 'Beni puanlar mısın? 👉👈';

  @override
  String get custom_arrays => 'Harf notu dizilerini kişiselleştir:';

  @override
  String get new_array => 'Kendi harf dizini oluştur;';

  @override
  String edit_array(Object oldName) {
    return '$oldName dizisini düzenle;';
  }

  @override
  String get default_array => 'Default diziyi görüntüle;';

  @override
  String get act_3_head2 => 'Hatalar ve düşüncelerinizi bize bildirin';

  @override
  String get ilk_bildo => 'SEEELLLLAMMM ! ! !';

  @override
  String get ilk_bildo_text =>
      'UniSaver\'ı kullandığın için teşekkür ederiz. Mükemmelsin!';

  @override
  String get pool1_1 =>
      'Finalleri son güne bıraktıysan, içini rahatlatmak için buradayım. 😊';

  @override
  String get pool1_2 => 'Bazı dersler de büte bırakılmalı dimi?¿ 🤠';

  @override
  String get pool1_3 => 'Kafadan planlamak zor gibi 🙄. Yine de ben buradayım!';

  @override
  String get pool2_1 => 'Ders seçimine de yardımcı olabileceğimi unutma. 😊';

  @override
  String get pool2_2 => 'Güz\'ü Bahar\'da toplarızzzzz. 😉';

  @override
  String get pool2_3 =>
      'Bir sene değil de yarım dönem uzatmana yardımcı olmak için buradayım. 😒';

  @override
  String get pool3_1 =>
      'Çok ders var hangisine odaklanacaksın? Gel beraber öğrenelim. 🧐';

  @override
  String get pool3_2 => 'Bazen vizeler de sallanabilir. 🤠';

  @override
  String get pool3_3 => 'Vizelerden planlarsan final haftasında yatarsın. 😉';

  @override
  String get pool4_1 =>
      'Final haftasında herkes telaş yaparken sen UniSaver kullan!';

  @override
  String get pool4_2 =>
      'Finaller bitsin süper bi tatil yaparız. Ama önce planlayalım. 😊';

  @override
  String get pool4_3 => 'ÇOK MU ZOR YA! UniSaver\'ı aç içini rahatlat. 🤗';

  @override
  String get pool5_1 => 'Yeni seneyi UniSaver\'da düşün, kafan rahat olsun. 🥳';

  @override
  String get pool5_2 => 'Tatil modundan çıkma vakti birazcık. 😒';

  @override
  String get pool5_3 => 'Ders seçiminde de UniSaver!!!';

  @override
  String get pool6_1 => 'Hangi dersi bırakacaksın, gel birlikte seçelim. 🥶';

  @override
  String get pool6_2 =>
      'Ne ara vizeler geldi ya, canın sıkıldıysa ben buradayım. ✋';

  @override
  String get pool6_3 =>
      'Diferansiyel Denklemler\'de Boğaziçili, vizelerde hangisine odaklanacağında UniSaver. 😇';

  @override
  String get head1 => 'BÜT MÜ¿ FİNAL Mİ? 🤨🤨🤨';

  @override
  String get head2 => 'Bahar\'a Birlikte Ders Seçelim 🙃';

  @override
  String get head3 => 'Fiyuu. Vizeler geliyor!';

  @override
  String get head4 => 'FİNALSSSS!';

  @override
  String get head5 => 'Yeni Seneye Hazır Mıyızzz??';

  @override
  String get head6 => 'Vizeler Yakın…';
}
