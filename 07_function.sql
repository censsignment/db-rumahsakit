USE db_rumah_sakit;

-- FUNCTION 1 : MENGHITUNG USIA PASIEN
DELIMITER //

CREATE FUNCTION fn_hitung_usia(p_tgl_lahir DATE)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    -- Deklarasi variabel untuk menyimpan hasil usia
    DECLARE v_usia INT;
    
    -- Jika tanggal lahir NULL, kembalikan NULL
    IF p_tgl_lahir IS NULL THEN
        RETURN NULL;
    END IF;
    
    -- Hitung usia dalam tahun
    -- Rumus: Tahun sekarang - tahun lahir, 
    --        tapi sesuaikan jika belum ulang tahun tahun ini
    SET v_usia = YEAR(CURDATE()) - YEAR(p_tgl_lahir);
    
    -- Kurangi 1 jika belum melewati hari ulang tahun di tahun ini
    IF DATE_ADD(p_tgl_lahir, INTERVAL v_usia YEAR) > CURDATE() THEN
        SET v_usia = v_usia - 1;
    END IF;
    
    -- Kembalikan hasil usia
    RETURN v_usia;
    
END //

DELIMITER ;

-- Contoh : Cari pasien lansia (usia > 20 tahun)
SELECT 
    nama_pasien,
    tgl_lahir,
    fn_hitung_usia(tgl_lahir) AS usia
FROM pasien
WHERE fn_hitung_usia(tgl_lahir) > 20;

-- FUNCTION 2 : MENGHITUNG TOTAL BIAYA OBAT
DELIMITER //

CREATE FUNCTION fn_total_biaya_obat(p_id_rekam_medis VARCHAR(10))
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(12,2);
    
    -- Jumlahkan semua harga obat dikali jumlah
    SELECT COALESCE(SUM(r.jumlah * o.harga_obat), 0)
    INTO v_total
    FROM resep r
    JOIN obat o ON r.id_obat = o.id_obat
    WHERE r.id_rekam_medis = p_id_rekam_medis;
    
    RETURN v_total;
    
END //

DELIMITER ;
SELECT 
    rm.id_rekam_medis,
    p.nama_pasien,
    fn_total_biaya_obat(rm.id_rekam_medis) AS total_biaya_obat
FROM rekam_medis rm
JOIN pendaftaran pf ON rm.id_pendaftaran = pf.id_pendaftaran
JOIN pasien p ON pf.id_pasien = p.id_pasien;