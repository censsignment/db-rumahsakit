USE db_rumah_sakit; 
DELIMITER //
CREATE PROCEDURE riwayat_pasien(
    IN p_id_pasien VARCHAR(10)
)
BEGIN
    SELECT
        p.nama_pasien,
        rm.tgl_pemeriksaan,
        rm.keluhan,
        rm.hasil_pemeriksaan,
        dg.diagnosa
    FROM pasien p
    JOIN pendaftaran pd
        ON p.id_pasien = pd.id_pasien
    JOIN rekam_medis rm
        ON pd.id_pendaftaran = rm.id_pendaftaran
    LEFT JOIN diagnosa dg
        ON rm.id_rekam_medis = dg.id_rekam_medis
    WHERE p.id_pasien = p_id_pasien;
END //
DELIMITER ;
CALL riwayat_pasien('PA20');