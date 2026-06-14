-- =====================================================
-- VIEW 1: view_riwayat_pasien
-- =====================================================

CREATE VIEW view_riwayat_pasien AS
SELECT 
    p.id_pasien,
    p.nama_pasien,
    p.jenis_kelamin,
    p.gol_darah,
    rm.id_rekam_medis,
    rm.keluhan,
    rm.hasil_pemeriksaan,
    rm.tgl_pemeriksaan,
    d.diagnosa,
    d.keterangan AS keterangan_diagnosa,
    o.nama_obat,
    r.dosis,
    r.jumlah AS jumlah_obat,
    r.aturan,
    dok.nama_dokter,
    dok.spesialis,
    po.nama_poli,
    po.lokasi AS lokasi_poli
FROM pasien p
JOIN pendaftaran pf ON p.id_pasien = pf.id_pasien
JOIN rekam_medis rm ON pf.id_pendaftaran = rm.id_pendaftaran
LEFT JOIN diagnosa d ON rm.id_rekam_medis = d.id_rekam_medis
LEFT JOIN resep r ON rm.id_rekam_medis = r.id_rekam_medis
LEFT JOIN obat o ON r.id_obat = o.id_obat
JOIN dokter dok ON rm.id_dokter = dok.id_dokter
JOIN poli po ON dok.id_poli = po.id_poli;

-- =====================================================
-- VIEW 2: view_laporan_harian
-- =====================================================

CREATE VIEW view_laporan_harian AS
SELECT 
    pf.tgl_daftar AS tanggal,
    po.nama_poli,
    d.nama_dokter,
    COUNT(DISTINCT pf.id_pendaftaran) AS jumlah_pasien,
    COUNT(DISTINCT rm.id_rekam_medis) AS jumlah_rekam_medis,
    COUNT(DISTINCT di.id_diagnosa) AS jumlah_diagnosa,
    COUNT(DISTINCT r.id_resep) AS jumlah_resep,
    COUNT(DISTINCT r.id_obat) AS jumlah_jenis_obat,
    ROUND(SUM(r.jumlah * o.harga_obat), 0) AS total_nilai_resep,
    ROUND(AVG(v.berat_badan), 1) AS rata_rata_berat_badan_pasien
FROM pendaftaran pf
JOIN jadwal j ON pf.id_jadwal = j.id_jadwal
JOIN dokter d ON j.id_dokter = d.id_dokter
JOIN poli po ON d.id_poli = po.id_poli
LEFT JOIN rekam_medis rm ON pf.id_pendaftaran = rm.id_pendaftaran
LEFT JOIN diagnosa di ON rm.id_rekam_medis = di.id_rekam_medis
LEFT JOIN resep r ON rm.id_rekam_medis = r.id_rekam_medis
LEFT JOIN obat o ON r.id_obat = o.id_obat
LEFT JOIN vital v ON rm.id_rekam_medis = v.id_rekam_medis
GROUP BY pf.tgl_daftar, po.nama_poli, d.nama_dokter
ORDER BY pf.tgl_daftar DESC, jumlah_pasien DESC;
